import UnityEngine
import UnityEngine.UI

class Indicator (MonoBehaviour): 

    private startPos as Vector2
    private targetFrame as int
    public amseq as Amseq
    public text as Text
    public lastTime as single
    public frameParent as Transform
    public framePrefab as GameObject

    def Start():
        print(amseq.frames.Count)
        for i in range(amseq.frames.Count):
            clone = Instantiate(framePrefab)
            clone.transform.SetParent(frameParent, false)
            clone.transform.localPosition = Vector3.zero
            clone.transform.localPosition.x = i 

    def OnMouseDown():
        print("click")
        startPos = transform.localPosition

    def OnMouseDrag():
        transform.position.x = Mathf.FloorToInt(Input.mousePosition.x)
        transform.localPosition.x = Mathf.Clamp(Mathf.FloorToInt(transform.localPosition.x), 0, 200)
        text.text = transform.localPosition.x.ToString()
        if transform.localPosition != startPos:
            amseq.GoToFrame(transform.localPosition.x)

    def GoToFrame(frame as int):
        transform.localPosition.x = frame
        amseq.GoToFrame(frame)
        text.text = transform.localPosition.x.ToString()

    def Update():
        if Input.GetKey(KeyCode.LeftArrow) and transform.localPosition.x > 0 and lastTime < Time.time - amseq.frameTime:
            transform.localPosition.x--
            GoToFrame(transform.localPosition.x)
            lastTime = Time.time

        if Input.GetKey(KeyCode.RightArrow) and transform.localPosition.x < amseq.frames.Count and lastTime < Time.time - amseq.frameTime:
            transform.localPosition.x++
            GoToFrame(transform.localPosition.x)
            lastTime = Time.time

    def SetFrameMarker(state as bool):
        print("frame marker true")
        frameParent.GetChild(transform.localPosition.x).gameObject.SetActive(state)