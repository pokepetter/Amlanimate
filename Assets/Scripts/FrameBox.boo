import UnityEngine
import UnityEngine.UI

class FrameBox (MonoBehaviour): 

    private startPos as Vector3
    private clickPos as Vector3
    private isMovingThis as bool
    private targetFrame as int
    # private frameManager as FrameManager
    # private frameAnimator as FrameGUI

    # def Awake():
    #     frameManager = GameObject.Find("frameManager").GetComponent(FrameManager)

    def OnMouseDown():
        startPos = Camera.main.ScreenToWorldPoint(Input.mousePosition)
        startPos.z = 0
        isMovingThis = true
        print(Mathf.FloorToInt(transform.position.x)+28)

    def OnMouseDrag():
        transform.position = Camera.main.ScreenToWorldPoint(Input.mousePosition) 
        transform.position.z = 0
        targetFrame = Mathf.FloorToInt(transform.position.x)   
        transform.position.x = targetFrame

    def OnMouseUp():
        isMovingThis = false
        # if Camera.main.ScreenToWorldPoint(Input.mousePosition).y <= -20:
            # frameManager.MoveFrame(Mathf.FloorToInt(startPos.x)+28, targetFrame+28)
            # frameAnimator.MoveFrame(Mathf.FloorToInt(startPos.x)+28, targetFrame+28)
        # else:
        #     transform.position = startPos
