

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>

#include "eyeGT.h"

#include "eyeGT_App.h"

#ifdef __cplusplus
extern "C" {
#endif
extern U8* screenSurface;
extern void updateScreen();
#ifdef __cplusplus
}
#endif

static U32 eyeGTCanvas;

#define BOTTOM_BORDER 10

signed long tmp3X;
signed long tmp4X;
signed long tmp5X;
signed long tmp3Y;
signed long tmp4Y;
signed long tmp5Y;

#define CLIENT_WIDTH 320 
#define CLIENT_HEIGHT 460

enum TParticlesID {
	pidLOGOSHAPE				= 51,
	pidMAINGRADIENTBACKGROUND	= 55,
	pidBACKGROUNDSHAPE			= 210,
	pidROPESHAPE				= 400,
};

typedef struct Anchor {
	SFLOAT x; 
	SFLOAT y; 
	SFLOAT xv;
	SFLOAT yv;
	BOOL isFixed;
} Anchor, *P_Anchor;

#define PI 3.14159265358979312L

static P_Anchor* anchors;

static int RopeLength;
static SFLOAT strength;
static SFLOAT friction;
static SFLOAT slidingFriction;
static SFLOAT gravity;
static SFLOAT restLength; 

static	int xPos;
static	int yPos;

static char* RopeShape; 

void CreateRope( void );
void UpdateRope( void );
void RenderRope( void );

void InitDemo();
//void DoMainLoop();

void eyeGT_App_Init()
{
	eyeGTCanvas = egtCreateCanvas();

	egtSetCanvasProperties(eyeGTCanvas, 320, 460, 32, true);

	egtSetRGBFieldLayout(eyeGTCanvas, rgb565);
	
	//Blue background
	egtSetBackgroundColor(eyeGTCanvas, 0, 0, 255);
	
	//we want to dither colors, this make the rendering a bit slower
	//but improve image quality on screen with less than 24 bits colors
	egtSetBitmapDither(eyeGTCanvas, DITHER_OFF);
	egtSetSolidColorDither(eyeGTCanvas, DITHER_OFF);
	
	egtSetUpdateRate(eyeGTCanvas, 30);
	
	egtSetAntialiasing(eyeGTCanvas, true);

	InitDemo();
}

void eyeGT_App_End()
{
	egtDestroyCanvas(eyeGTCanvas);
}


void eyeGT_App_RenderFrame(TsRECT* rct)
{
	UpdateRope();

	egtSetDisplaySurface(eyeGTCanvas, screenSurface, false);

	egtProcessDisplayList(eyeGTCanvas, true);

	egtDrawAllLayers(eyeGTCanvas);

	//make sure we clear the update area
	egtGetFrameBufferDirtyRect(eyeGTCanvas, rct);

	updateScreen();
}

void DoPointerDown(int X, int Y)
{
	egtMouseDown(eyeGTCanvas, X, Y);
}

void DoPointerUp(int X, int Y)
{
	egtMouseUp(eyeGTCanvas, X, Y);
}

void DoPointerMove(int X, int Y)
{
	egtMouseMove(eyeGTCanvas, X, Y, true);
	
	xPos = X; 
	yPos = Y; 
	
	if (xPos < 10) { xPos = 10; }
	if (xPos > CLIENT_WIDTH-10) { xPos = CLIENT_WIDTH-10; }
	
	if (yPos < 10) { yPos = 10; }
	if (yPos > CLIENT_HEIGHT-10) { yPos = CLIENT_HEIGHT-10; }
}

void inDoScale(SFLOAT scalevalue)
{
}

SFLOAT GetCurrentScale()
{
	return 1.0;
}

void InitDemo()
{
	//Initialize the variables used to compute rope shape
	anchors = 0;
	
	RopeLength = 15;
	strength = 0.8;
	friction = 0.95;
	slidingFriction = 0.5;
	gravity = 0.3;
	restLength = 6; 
	
	xPos = CLIENT_WIDTH / 2;
	yPos = CLIENT_HEIGHT / 2;
	
	RopeShape = NULL;
	
	//Create the rope
	CreateRope();
}

void CreateRope( void )
{
	if (anchors) delete [] anchors;
	
	anchors = new P_Anchor[RopeLength];
	
	for (int i=0; i < RopeLength; i++)
	{
		anchors[i] = new Anchor;
		anchors[i]->x = i * 2.0;
		anchors[i]->y = i * 2.0;
		anchors[i]->xv = 0.0;
		anchors[i]->yv = 0.0;
		anchors[i]->isFixed = false;
	}
	
	anchors[0]->isFixed = true;
	
	
	TsFloatRECT rct;
	
	rct.xmin = 0;
	rct.ymin = 0;
	rct.xmax = CLIENT_WIDTH;
	rct.ymax = CLIENT_HEIGHT;
	
	
	//Create the shape
#if defined(USE_CANVAS_SHAPE)
	egtCreateCanvasShape(eyeGTCanvas, pidROPESHAPE, 400, 0, 0, &rct, &RopeShape );
#else
	egtCreateShape(eyeGTCanvas, pidROPESHAPE, &rct );
	egtCreatePenStyle(eyeGTCanvas,  15.0, 255, 255, 255, 255);
	egtPlaceParticleInstance(eyeGTCanvas, pidROPESHAPE, 400, NULL, 0, 0, NULL, &RopeShape );
#endif	
}

// get Distance between two points
SFLOAT getDistance( SFLOAT x1, SFLOAT y1, SFLOAT x2, SFLOAT y2 )
{
	SFLOAT dx = x1-x2;
	SFLOAT dy = y1-y2;
	return sqrt( dx*dx + dy*dy );
}

// get Angle between two points
SFLOAT getAngle( SFLOAT x1, SFLOAT y1, SFLOAT x2, SFLOAT y2 )
{
	SFLOAT dx = x1-x2;
	SFLOAT dy = y1-y2;
	return atan2( dy, dx );
}

void UpdateRope( void )
{
	anchors[0]->x = xPos;
	anchors[0]->y = yPos;
	
	for (int i=0; i < RopeLength-1; i++)
	{
		Anchor* b1 = anchors[i];
		Anchor* b2 = anchors[i+1];
		SFLOAT x1 = b1->x;
		SFLOAT y1 = b1->y;
		SFLOAT x2 = b2->x;
		SFLOAT y2 = b2->y;
		
		SFLOAT d = getDistance( x1, y1, x2, y2 );
		SFLOAT a = getAngle( x1, y1, x2, y2 )-PI/2;
		SFLOAT f = ( restLength - d ) * strength;
		
		SFLOAT fx = sin(a) * f / 2.0;
		SFLOAT fy = cos(a) * f / 2.0;
		
		if(!b1->isFixed)
		{
			b1->xv -= fx / 2.0;
			b1->yv += fy / 2.0;
		}
		
		if(!b2->isFixed){
			b2->xv += fx / 2.0;
			b2->yv -= fy / 2.0;
		}
	}
	
	for(int i=0; i < RopeLength; i++)
	{
		Anchor* a = anchors[i];
		
		if(!a->isFixed)
		{
			a->yv += gravity;
			a->xv *= friction;
			a->yv *= friction;
			a->x += a->xv;
			a->y += a->yv;
		}
		
		if(a->x < BOTTOM_BORDER)
		{
			a->x = BOTTOM_BORDER;
			a->xv *= -friction;
			a->yv *= slidingFriction;
		}
		
		if(a->x > (CLIENT_WIDTH - BOTTOM_BORDER))
		{
			a->x = CLIENT_WIDTH - BOTTOM_BORDER;
			a->xv *= -friction;
			a->yv *= slidingFriction;
		}
		
		if(a->y < BOTTOM_BORDER)
		{
			a->y = BOTTOM_BORDER;
			a->yv *= -friction;
			a->xv *= slidingFriction;
		}
		
		if(a->y > (CLIENT_HEIGHT - BOTTOM_BORDER))
		{
			a->y = CLIENT_HEIGHT - BOTTOM_BORDER;
			a->yv *= -friction;
			a->xv *= slidingFriction;
		}
	}
	
	RenderRope();
}

// renders the chain
void RenderRope( void )
{
#if defined(USE_CANVAS_SHAPE)
	egtClearShape(eyeGTCanvas,  pidROPESHAPE, CLEAR_CANVAS );
	egtSelectShape(eyeGTCanvas,  pidROPESHAPE );
	egtCreatePenStyle(eyeGTCanvas,  8.0, 255, 255, 255, 255);
#else
	egtClearShape(eyeGTCanvas, pidROPESHAPE, CLEAR_INSTRUCTIONS );
#endif
	
	egtSelectPenStyle(eyeGTCanvas,  1 );
	
	egtMoveTo(eyeGTCanvas,  anchors[0]->x, anchors[0]->y );
	
	SFLOAT px = anchors[0]->x;
	SFLOAT py = anchors[0]->y;
	
	for ( int i = 1; i < RopeLength; i++)
	{
		Anchor* a = anchors[i];
		SFLOAT mx = (px + a->x) / 2.0;
		SFLOAT my = (py + a->y) / 2.0;
		
		egtQuadricCurveTo(eyeGTCanvas,  px, py, mx, my );
		
		px = a->x;
		py = a->y;
	}
	
	egtSelectPenStyle(eyeGTCanvas,  PEN_OFF );
	
	egtRefreshInstance(eyeGTCanvas, RopeShape );
}
