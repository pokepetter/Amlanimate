import UnityEngine
import UnityEngine.UI

class FrameManager (MonoBehaviour): 

    public framePrefab as GameObject
    public frameBoxPrefab as GameObject
    public frameIndicator as Transform
    public currentFrameNumber as int
    public frames as (GameObject)
    public frameBoxes as (GameObject)
    public layer1 as Transform
    public layer1GUI as Transform
    public autoCreateFrames as bool
    public showTweenFrames as bool
    private tempFrame as GameObject
    private prevFrameDrawing as (GameObject)
    private nextFrameDrawing as (GameObject)

    def Awake():
        frames = array(GameObject, 24)
        frameBoxes = array(GameObject, 100)
        CreateFrame(0)

    def CreateFrame(newFramePosition as int):
        print("create frame at " + newFramePosition)
        newFrame = Instantiate(framePrefab)
        newFrame.transform.parent = layer1
        newFrame.transform.localPosition.y = 2.5f
        frames[newFramePosition] = newFrame
        for frame in frames:
                if frame != null:
                    frame.SetActive(false)
        frames[newFramePosition].SetActive(true)
        currentFrameNumber = newFramePosition

        //timeline box
        newBox = Instantiate(frameBoxPrefab)
        newBox.transform.parent = layer1GUI
        frameBoxes[newFramePosition] = newBox
        currentFrameNumber = newFramePosition
        newBox.transform.position.x = currentFrameNumber-28
        newBox.transform.localPosition.y = 0


    def Update():
        frameIndicator.transform.position.x = currentFrameNumber-28

        if Input.GetMouseButtonDown(0) and autoCreateFrames:
            if frames[currentFrameNumber] == null:
                CreateFrame(currentFrameNumber)

        if Input.GetKeyDown(KeyCode.N):
            if frames[currentFrameNumber] == null:
                CreateFrame(currentFrameNumber)
            else:
                for fb in frames:
                    currentFrameNumber++
                    if frameBoxes[currentFrameNumber] == null:
                        CreateFrame(currentFrameNumber)
                        break

        if Input.GetKeyDown(KeyCode.RightArrow):
            for frame in frames:
                if frame != null:
                    frame.SetActive(false)
            currentFrameNumber++
            if frames[currentFrameNumber] != null:
                frames[currentFrameNumber].SetActive(true)

                
        if Input.GetKeyDown(KeyCode.LeftArrow):
            for frame in frames:
                if frame != null:
                    frame.SetActive(false)
            if currentFrameNumber > 0:
                currentFrameNumber--
                if frames[currentFrameNumber] != null:
                    frames[currentFrameNumber].SetActive(true)



    def MoveFrameBox(i as int, targetFrame as int):
        if frameBoxes[targetFrame] == null:
            frameBoxes[targetFrame] = frameBoxes[i]
            frameBoxes[i] = null 
            # frameAnimator.frames[targetFrame] = frameAnimator.frames[i]
            # frameAnimator.frames[i] = null
        else:
            tempFrame = frameBoxes[i]
            frameBoxes[i] = frameBoxes[targetFrame]
            frameBoxes[targetFrame] = tempFrame
            
            
    def GoToFrame(newFrame as int):
        //move frame indicator thing
        currentFrameNumber = newFrame

        
        
    # def MakeTweenFrame():
    #     CreateFrame(currentFrameNumber)

    #     pf as VectorLineDrawing = frames[currentFrameNumber-1].GetComponent(VectorLineDrawing)
    #     if frames[currentFrameNumber+1] != null:
    #         nf as VectorLineDrawing = frames[currentFrameNumber+1].GetComponent(VectorLineDrawing)
    #     currentDrawing = frames[currentFrameNumber].GetComponent(VectorLineDrawing)

    #     if pf != null and nf != null:
    #         j as int = 0
    #         while j < 512:
    #             if pf.shape[j] != null and nf.shape[j] != null:
    #                 newPos as Vector3 = pf.shape[j].transform.position + ((nf.shape[j].transform.position - pf.shape[j].transform.position) / 2f)
    #                 newPoint = Instantiate(currentDrawing.pointPrefab, newPos, Quaternion.identity) as GameObject
    #                 newPoint.transform.parent = currentDrawing.transform
    #                 currentDrawing.shape[j] = newPoint
    #                 if j > 0:
    #                     currentDrawing.shape[j].transform.GetComponent(LineRenderer).SetPosition(1, currentDrawing.shape[j-1].transform.position)
    #                 else:
    #                     currentDrawing.shape[j].transform.GetComponent(LineRenderer).SetPosition(1, currentDrawing.shape[j].transform.position)
    #             j++
    #     else:
    #         print("No frames to tween")


    def MoveFrame(i as int, targetFrame as int):
        if frames[targetFrame] == null:
            frames[targetFrame] = frames[i]
            frames[i] = null 
            print("moved frame to "+targetFrame)
        else:
            tempFrame = frames[i]
            frames[i] = frames[targetFrame]
            frames[targetFrame] = tempFrame
            
        
        
        
        
