#include "eyeGT.h"
#include "eyeGTTypes.h"
#include "eyeGTSym.h"

#ifdef __cplusplus
extern "C" {
#endif
	
void iPhone_Video_End();
void iPhone_Video_LoadFrame(TsRECT* rct);
void iPhone_Video_Init(char* AppPath);

void eraseDrawing();

void inMouseDown(int X, int Y);
void inMouseUp(int X, int Y);
void inMouseMove(int X, int Y);
void inDoScale(SFLOAT scalevalue);
void inDoubleTap(int X, int Y);
void inDoAngle(SFLOAT anglevalue);
SFLOAT GetCurrentScale();
SFLOAT GetCurrentAngle();
int GetPendingOperation();
void ChangeShape();
#ifdef __cplusplus
}
#endif

