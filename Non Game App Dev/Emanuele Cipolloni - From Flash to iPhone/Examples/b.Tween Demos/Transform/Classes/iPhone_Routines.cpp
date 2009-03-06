
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>

#include "iPhone_Routines.h"
#include "CommonTransform.h"
#include "CommonTransformDefs.h"

#ifdef __cplusplus
extern "C" {
#endif
	extern U8* screenSurface;
	extern void updateScreen();
#ifdef __cplusplus
}
#endif

static bool ismousedown = false;

static bool firstrefresh = true;

//Starting path of the application
static char* basePath = NULL;

//The Transform main object that contains the whole object
CCommonTransform* CommonTransform = NULL;

static int meXpos, meYpos;

#define CLIENT_WIDTH 320 
#define CLIENT_HEIGHT 460

void InitDemo();

void iPhone_Video_Init(char* AppPath)
{
	basePath = (char*) malloc(strlen(AppPath)+1);
	
	memset(basePath, 0, strlen(AppPath));
	
	memcpy(basePath, AppPath, strlen(AppPath));
	
	//Create the rendering surface           
	CommonTransform = (CCommonTransform*) new CCommonTransform((char*) basePath,  32, true, ( CLIENT_WIDTH + 3 ) & ( ~0x03 ), CLIENT_HEIGHT);
		
	egtSetDisplaySurface(CommonTransform->eyeGTCanvas, screenSurface, true);
}

void iPhone_Video_End()
{
	delete CommonTransform;
	
	if (basePath) free(basePath);
}


void iPhone_Video_LoadFrame(TsRECT* rct)
{
	
	CommonTransform->DoPeriodTask();
	
	//make sure we clear the update area
	if (firstrefresh)
	{	
		firstrefresh = false;
		
		egtGetFrameBufferDirtyRect(CommonTransform->eyeGTCanvas, NULL);
		
		rct->xmin = 0;
		rct->ymin = 0;
		rct->xmax = 319;
		rct->ymax = 459;
	}
	else
	{	
		egtGetFrameBufferDirtyRect(CommonTransform->eyeGTCanvas, rct);
	}
	
	updateScreen();
}

void inMouseDown(int X, int Y)
{
    meXpos = X; 
	meYpos = Y;
	
	CommonTransform->PointerDown(X, Y);
}

void inMouseUp(int X, int Y)
{
    CommonTransform->PointerUp(X, Y);
}

void inMouseMove(int X, int Y)
{
    CommonTransform->PointerMove(X, Y);
	
    meXpos = X; 
    meYpos = Y;
}

void inDoubleTap(int X, int Y)
{
}

void inDoScale(SFLOAT scalevalue)
{
}


SFLOAT GetCurrentScale()
{
	return 1.0;
}

void inDoAngle(SFLOAT anglevalue)
{
}

SFLOAT GetCurrentAngle()
{	
	return 0.0;
}

int GetPendingOperation()
{
	return 0;
}

void ChangeShape()
{
	 CommonTransform->ChangeShape();
}

