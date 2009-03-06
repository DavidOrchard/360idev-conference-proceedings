#include "eyeGT.h"
#include "eyeGTTypes.h"
#include "eyeGTSym.h"

#ifdef __cplusplus
extern "C" {
#endif
	
void eyeGT_App_Init();
void eyeGT_App_End();
void eyeGT_App_RenderFrame(TsRECT* rct);
	
void DoPointerDown(int X, int Y);
void DoPointerUp(int X, int Y);
void DoPointerMove(int X, int Y);
	
void inDoScale(SFLOAT scalevalue);
SFLOAT GetCurrentScale();

#ifdef __cplusplus
}
#endif

