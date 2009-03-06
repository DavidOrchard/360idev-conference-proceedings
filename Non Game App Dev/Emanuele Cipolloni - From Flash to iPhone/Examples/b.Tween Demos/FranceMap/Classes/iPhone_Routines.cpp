
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>

#include "iPhone_Routines.h"
#include "objlist.h"
#include "eyeGT_Utilities.h"
#include "eyeGTFixedMath.h"

#ifdef __cplusplus
extern "C" {
#endif
extern U8* screenSurface;
extern void updateScreen();
#ifdef __cplusplus
}
#endif

static U32 eyeGTCanvas;

static bool ismousedown = false;

static bool firstrefresh = true;

static char* basePath = NULL;

static char TempBuffer[1024];

#define CLIENT_WIDTH 320 
#define CLIENT_HEIGHT 460

enum TParticlesID {
	pidHOLDER					= 5000,
	pidFranceBlueShape			= 6000
};

#if defined(USE_FIXED)
static SFIXED angleY;
static SFIXED MouseX, MouseY;
#else
static SFLOAT angleY;
static SFLOAT MouseX, MouseY;
#endif

static TObjList* points;

void draw();

//Structure to hold 3D Points
class TVector3D : public BaseListObj 
	{
	public:
		#if defined(USE_FIXED)
		SFIXED x, y, z;
		#else
		SFLOAT x, y, z;
		#endif
		
		bool marker;
		
		TVector3D() { x = 0; y = 0; z = 0; marker = false; };
	};


void InitDemo();

void iPhone_Video_Init(char* AppPath)
{
	eyeGTCanvas = egtCreateCanvas();

	egtSetCanvasProperties(eyeGTCanvas, 320, 460, 32, true);

	egtSetRGBFieldLayout(eyeGTCanvas, rgb555);
	
	egtSetAntialiasing(eyeGTCanvas, false);

	//black background
	egtSetBackgroundColor(eyeGTCanvas, 0, 0, 0);
	
	//we want to dither colors, this make the rendering a bit slower
	//but improve image quality on screen with less than 24 bits colors
	egtSetBitmapDither(eyeGTCanvas, DITHER_OFF);
	egtSetSolidColorDither(eyeGTCanvas, DITHER_OFF);
	
	egtSetUpdateRate(eyeGTCanvas, 30);

	egtSetDisplaySurface(eyeGTCanvas, screenSurface, true);
	
	basePath = (char*) malloc(strlen(AppPath)+1);
	
	memset(basePath, 0, strlen(AppPath));
	
	memcpy(basePath, AppPath, strlen(AppPath));
	
	sprintf(TempBuffer, "%s/FranceBlue.mhp", basePath);
	
	U8* FranceBlueMHP = NULL;
	
	int FranceBlueLEN = efReadParticleFile(&FranceBlueMHP, TempBuffer);
	
	if (FranceBlueLEN > 0)
	{
		egtLoadMultiShape(eyeGTCanvas, pidFranceBlueShape, 10, FranceBlueMHP, FranceBlueLEN, true);
		
		free(FranceBlueMHP);
	}
	
	egtCreateContainer(eyeGTCanvas, pidFranceBlueShape - 1);
	
	egtContainerPlaceParticle(eyeGTCanvas, pidFranceBlueShape - 1, pidFranceBlueShape + 0, 1, "HOLDER10", 199.25, 237.8);

	egtContainerPlaceParticle(eyeGTCanvas, pidFranceBlueShape - 1, pidFranceBlueShape + 1, 2, "HOLDER11", 201.2, 209.2);
	
	egtContainerPlaceParticle(eyeGTCanvas, pidFranceBlueShape - 1, pidFranceBlueShape + 2, 3, "HOLDER12",  203.9, 224.25);
	
	egtContainerPlaceParticle(eyeGTCanvas, pidFranceBlueShape - 1, pidFranceBlueShape + 3, 4, "HOLDER13", 228.1, 260.7);
	
	egtContainerPlaceParticle(eyeGTCanvas, pidFranceBlueShape - 1, pidFranceBlueShape + 4, 5, "HOLDER14", 230.7, 264.4);

	egtContainerPlaceParticle(eyeGTCanvas, pidFranceBlueShape - 1, pidFranceBlueShape + 5, 6, "HOLDER15", 238.15, 314);
	
	egtContainerPlaceParticle(eyeGTCanvas, pidFranceBlueShape - 1, pidFranceBlueShape + 6, 7, "HOLDER16", 241.8, 315);
	
	egtContainerPlaceParticle(eyeGTCanvas, pidFranceBlueShape - 1, pidFranceBlueShape + 7, 8, "HOLDER17", 248.2, 313.55);
	
	egtContainerPlaceParticle(eyeGTCanvas, pidFranceBlueShape - 1, pidFranceBlueShape + 8, 9, "HOLDER18", 350.45, 267.05);

	egtContainerPlaceParticle(eyeGTCanvas, pidFranceBlueShape - 1, pidFranceBlueShape + 9, 10, "HOLDER19", 205.05, 199.9);

	
	egtPlaceParticleInstance(eyeGTCanvas, pidFranceBlueShape - 1, 2000, "HOLDER2", 0, 0, NULL, NULL);
							  
	InitDemo();
}

void iPhone_Video_End()
{
	egtDestroyCanvas(eyeGTCanvas);
	
	if (basePath) free(basePath);
}


void iPhone_Video_LoadFrame(TsRECT* rct)
{
	//draw();

	egtProcessDisplayList(eyeGTCanvas, true);

	egtDrawAllLayers(eyeGTCanvas);

	//make sure we clear the update area
	if (firstrefresh)
	{	
		firstrefresh = false;
		
		egtGetFrameBufferDirtyRect(eyeGTCanvas, NULL);
		
		rct->xmin = 0;
		rct->ymin = 0;
		rct->xmax = 319;
		rct->ymax = 459;
	}
	else
	{	
		egtGetFrameBufferDirtyRect(eyeGTCanvas, rct);
	}
	
	updateScreen();
}

void inMouseDown(int X, int Y)
{
	egtMouseDown(eyeGTCanvas, X, Y);
	
	ismousedown = true;
	
	#if defined(USE_FIXED)
	MouseX = DoubleToFixed(X - 160);
	MouseY = DoubleToFixed(Y - 230);
	#else
	MouseX = (X - 160);
	MouseY = (Y - 230);
	#endif

	/*
	egtSetInstanceVisibility(eyeGTCanvas, "/HOLDER2/HOLDER11", false);
	egtSetInstanceVisibility(eyeGTCanvas, "/HOLDER2/HOLDER12", false);
	egtSetInstanceVisibility(eyeGTCanvas, "/HOLDER2/HOLDER13", false);
	egtSetInstanceVisibility(eyeGTCanvas, "/HOLDER2/HOLDER14", false);
	egtSetInstanceVisibility(eyeGTCanvas, "/HOLDER2/HOLDER15", false);
	egtSetInstanceVisibility(eyeGTCanvas, "/HOLDER2/HOLDER16", false);
	egtSetInstanceVisibility(eyeGTCanvas, "/HOLDER2/HOLDER17", false);
	egtSetInstanceVisibility(eyeGTCanvas, "/HOLDER2/HOLDER18", false);
	egtSetInstanceVisibility(eyeGTCanvas, "/HOLDER2/HOLDER19", false);
	 */
}

void inMouseUp(int X, int Y)
{
	egtMouseUp(eyeGTCanvas, X, Y);
	
	ismousedown = false;
	
	TVector3D* point = (TVector3D*) new TVector3D();
	
	point->marker = true;
	
	points->AddObject(NULL, point, 0);

	egtSetInstanceVisibility(eyeGTCanvas, "/HOLDER2/HOLDER11", true);
	egtSetInstanceVisibility(eyeGTCanvas, "/HOLDER2/HOLDER12", true);
	egtSetInstanceVisibility(eyeGTCanvas, "/HOLDER2/HOLDER13", true);
	egtSetInstanceVisibility(eyeGTCanvas, "/HOLDER2/HOLDER14", true);
	egtSetInstanceVisibility(eyeGTCanvas, "/HOLDER2/HOLDER15", true);
	egtSetInstanceVisibility(eyeGTCanvas, "/HOLDER2/HOLDER16", true);
	egtSetInstanceVisibility(eyeGTCanvas, "/HOLDER2/HOLDER17", true);
	egtSetInstanceVisibility(eyeGTCanvas, "/HOLDER2/HOLDER18", true);
	egtSetInstanceVisibility(eyeGTCanvas, "/HOLDER2/HOLDER19", true);
}

void inMouseMove(int X, int Y)
{
	egtMouseMove(eyeGTCanvas, X, Y, true);

	egtTranslateInstance(eyeGTCanvas, "/HOLDER2", X - 200, Y - 200, false);
	
	//egtScaleInstance(eyeGTCanvas, "/HOLDER2", 0.01, 0.01, true);
	
	
	#if defined(USE_FIXED)
	MouseX = DoubleToFixed(X - 160);
	MouseY = DoubleToFixed(Y - 230);
	#else
	MouseX = (X - 160);
	MouseY = (Y - 230);
	#endif
}

void inDoScale(SFLOAT scalevalue)
{
	egtScaleInstance(eyeGTCanvas, "/SQUARE", scalevalue, scalevalue, false);
}

SFLOAT GetCurrentScale()
{
	SFLOAT ScaleX, ScaleY;
	egtGetInstanceScaling(eyeGTCanvas, "/SQUARE", &ScaleX, &ScaleY);

	return ScaleX;
}

void InitDemo()
{
	TsFloatRECT rct;
	
	rct.xmin = -160;
	rct.ymin = -130;
	rct.xmax = 160;
	rct.ymax = 130;
	
	egtCreateShape(eyeGTCanvas, pidHOLDER, &rct);
		
	for (int i = 0; i < 256; i++)
	{
		egtCreatePenStyle(eyeGTCanvas, 8.0, i, i, i, 255);
	}
	
	egtPlaceParticleInstance(eyeGTCanvas, pidHOLDER, 6000, "HOLDER", 160, 230, NULL, NULL);
	
	points = (TObjList*) new TObjList(true);
	
	#if defined(USE_FIXED)
	angleY = DoubleToFixed(-0.5);
	#else
	angleY = (-0.5);
	#endif
}


#if defined(USE_FIXED)
void draw()
{
	if (ismousedown)
	{
		TVector3D* point = (TVector3D*) new TVector3D();
		
		point->x = egtMultiplyFP(MouseX, DoubleToFixed(1.5));
		point->y = egtMultiplyFP(MouseY, DoubleToFixed(1.5));
		
		points->AddObject(NULL, point, 0);
	}
	
	egtClearShape(eyeGTCanvas, pidHOLDER, CLEAR_INSTRUCTIONS);
	egtSelectShape(eyeGTCanvas, pidHOLDER);
	
	SFIXED _cos = egtCosFP(angleY);
	SFIXED _sin = egtSinFP(angleY);
	
	TVector3D* p = NULL;
	int i;
	
	for (i = 0; i < points->Count(); i++)
	{
		p = (TVector3D*) points->GetStringByPosition(i);
		
		if (!p->marker)
		{
			SFIXED x1 = egtMultiplyFP(p->x, _cos) - egtMultiplyFP(p->z, _sin);
			SFIXED z1 = egtMultiplyFP(p->z, _cos) + egtMultiplyFP(p->x, _sin);
			
			p->x = x1;
			p->z = z1;
		}
	}
	
	
	for (i = 0; i < points->Count(); i++)
	{
		p = (TVector3D*) points->GetStringByPosition(i);
		
		if (!p->marker)
		{
			
			SFIXED scale = egtDivideFP(DoubleToFixed(320.0), DoubleToFixed(320.0) + p->z + DoubleToFixed(160.0));
			
			egtSelectPenStyle(eyeGTCanvas, FixedToDouble(egtMultiplyFP(scale, DoubleToFixed(100.0))));
			
			if (i == 0)
			{
				egtMoveToFP(eyeGTCanvas, FixedToTwips(egtMultiplyFP(p->x, scale)), FixedToTwips(egtMultiplyFP(p->y, scale)));
			}
			else
			{
				egtLineToFP(eyeGTCanvas, FixedToTwips(egtMultiplyFP(p->x, scale)), FixedToTwips(egtMultiplyFP(p->y, scale)));
			}
		}
		else
		{
			i++;
			
			if (i < points->Count())
			{
				p = (TVector3D*) points->GetStringByPosition(i);
				
				SFIXED scale = egtDivideFP(DoubleToFixed(320.0), DoubleToFixed(320.0) + p->z + DoubleToFixed(160.0));
				
				egtMoveToFP(eyeGTCanvas, FixedToTwips(egtMultiplyFP(p->x, scale)), FixedToTwips(egtMultiplyFP(p->y, scale)));
			}
		}
	}
	
	egtRefreshInstance(eyeGTCanvas, "/HOLDER");
}
#else
void draw()
{
	if (ismousedown)
	{
		TVector3D* point = (TVector3D*) new TVector3D();
		
		point->x = MouseX * 1.5;
		point->y = MouseY * 1.5;
		
		points->AddObject(NULL, point, 0);
	}
	
	egtClearShape(eyeGTCanvas, pidHOLDER, CLEAR_INSTRUCTIONS);
	egtSelectShape(eyeGTCanvas, pidHOLDER);
	
	SFLOAT _cos = cos(angleY);
	SFLOAT _sin = sin(angleY);
	
	TVector3D* p = NULL;
	int i;
	
	for (i = 0; i < points->Count(); i++)
	{
		p = (TVector3D*) points->GetStringByPosition(i);
		
		if (!p->marker)
		{
			SFLOAT x1 = p->x * _cos - p->z * _sin;
			SFLOAT z1 = p->z * _cos + p->x * _sin;
			
			p->x = x1;
			p->z = z1;
		}
	}
	
	
	for (i = 0; i < points->Count(); i++)
	{
		p = (TVector3D*) points->GetStringByPosition(i);
		
		if (!p->marker)
		{
			
			SFLOAT scale = 320.0 / (320.0 + p->z + 160.0);
			
			egtSelectPenStyle(eyeGTCanvas, scale * 100.0);
			
			if (i == 0)
			{
				egtMoveTo(eyeGTCanvas, p->x * scale, p->y * scale);
			}
			else
			{
				egtLineTo(eyeGTCanvas, p->x * scale, p->y * scale);
			}
		}
		else
		{
			i++;
			
			if (i < points->Count())
			{
				p = (TVector3D*) points->GetStringByPosition(i);
				
				SFLOAT scale = 320.0 / (320.0 + p->z + 160.0);
				
				egtMoveTo(eyeGTCanvas, p->x * scale, p->y * scale);
			}
		}
	}
	
	egtRefreshInstance(eyeGTCanvas, "/HOLDER");
}
#endif

void eraseDrawing()
{
	points->Clear();
}
