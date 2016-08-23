import UnityEngine
import System.Collections
import System.IO
#import System.Windows.Clipboard

class Draw (MonoBehaviour): 

    public renderTexture as RenderTexture
    public outputCamera as Camera
    private tex as Texture2D
    private rect as Rect
    private bytes as (byte)
    public projectName as string

    public linePrefab as TrailRenderer
    public eraserPrefab as TrailRenderer
    public currentColor as Color
    public bgColor as Color
    public framePrefab as GameObject
    public followMouse as bool
    private pan as bool
    public customCursor as Texture2D
    public frame as int
    public maxFrames as int
    public frameCounter as Text
    public maxFramesCounter as Text
    public fps as single = 24
    public frameSkip as int = 1
    public fpsCounter as Text
    public frameSkipCounter as Text
    public returnToFrameAfterPlay as bool = true
    
    public canvasParent as Transform
    public border as Transform    
    public layers as Transform
    public undoLayers as Transform
    public currentLayer as int
    
    public playing as bool

    private currentLine as TrailRenderer
    private currentFrame as int
    public i as int = 1
    private j as int = 0
    public indexCounter as Text
    
    public enum tool:
        pen = 0
        eraser = 1
        move = 2
    private currentTool as tool

    def Start():
        Screen.orientation = ScreenOrientation.LandscapeLeft

    def Awake():
        currentTool = tool.pen
#        System.Windows.Clipboard.SetText("Sample paste")
        Cursor.SetCursor(customCursor, Vector2.zero, CursorMode.Auto)
        Cursor.visible = true
        
        layerIndex as int = 0
        while layerIndex < layers.childCount:
            frame = 0
            while frame < maxFrames+1:
                frameParent as GameObject = GameObject("frame" + frame)
                frameParent.transform.parent = layers.GetChild(layerIndex)
                undoFrameParent as GameObject = GameObject("undoFrame" + frame)
                undoFrameParent.transform.parent = undoLayers.GetChild(layerIndex)
                frame++
            layerIndex++
            
        if frame >= maxFrames:
            frame = 0
            
    def OnMouseDown():
        if currentTool == tool.pen:
            line as TrailRenderer = Instantiate(linePrefab)
            currentLine = line
            currentLine.transform.parent = layers.GetChild(currentLayer).GetChild(frame)
            currentLine.gameObject.name = "line" + i
            line.material.color = currentColor
            i++
            followMouse = true
            
        if currentTool == tool.eraser:
            eraserLine as TrailRenderer = Instantiate(eraserPrefab)
            currentLine = eraserLine
            currentLine.transform.parent = layers.GetChild(currentLayer).GetChild(frame)
            currentLine.gameObject.name = "eraserLine" + i
            eraserLine.material.color = bgColor
            i++
            followMouse = true

    def OnMouseUp():
        followMouse = false

    def Pen():
        currentTool = tool.pen
        
    def Eraser():
        currentTool = tool.eraser
    
    def Clear():
        pass
        
    def Move():
        currentTool = tool.move
        if pan == true:
            pan = false
        else:
            pan = true


    def Update():
        indexCounter.text = i.ToString()

        Camera.main.backgroundColor = bgColor

        if followMouse == true:
            p as Vector3 = Camera.main.ScreenToWorldPoint(Vector3(Input.mousePosition.x, Input.mousePosition.y, 10 - (0.001 * i+1)))
            currentLine.transform.position = p
            
//toggle eraser
        if Input.GetMouseButtonDown(1):
            tempColor as Color = currentColor
            currentColor = Color.white
                
        if Input.GetMouseButtonUp(1):
            currentColor = tempColor

//pan
        if Input.GetKeyDown(KeyCode.Space):
            pan = true
            
        if Input.GetKeyUp(KeyCode.Space):
            pan = false
            border.parent = transform
        
        if Input.GetMouseButtonDown(0) and pan == true and currentTool == tool.move:
            border.parent = null
            startPan as Vector3 = Camera.main.ScreenToWorldPoint(Vector3(Input.mousePosition.x, Input.mousePosition.y, 10))
            transform.position = startPan
#        if Input.GetMouseButtonUp(0) and pan == false:

//zoom  
        Camera.main.orthographicSize -= Input.GetAxis("Mouse3")
        canvasParent.localScale -= Vector3.one * Input.GetAxis("Mouse3") /5.4
        if Input.GetMouseButtonDown(2):
            Camera.main.orthographicSize = 5.4
            canvasParent.localScale = Vector3.one
        

//undo
        if Input.GetKeyDown(KeyCode.Z):
            Undo()
            
            
        elif Input.GetKeyDown(KeyCode.Z):
            print("nothing to undo")
//redo
        if Input.GetKeyDown(KeyCode.X):
            Redo()

//frames
        if Input.GetButtonDown("NextFrame"):
            NextFrame()

        if Input.GetButtonDown("PreviousFrame"):
            PreviousFrame()

        frameCounter.text = frame.ToString()
        maxFramesCounter.text = maxFrames.ToString()
        transform.position.x = frame*20
        
        fpsCounter.text = fps.ToString()
        frameSkipCounter.text = frameSkip.ToString()

//playback
        if playing == false:
            if Input.GetButtonDown("Play"):
                StartCoroutine(Play())
                playing = true


        if playing == true:
            if Input.GetButtonUp("Play"):
                StopAllCoroutines()
                Stop()
                playing = false
                
//save
        if Input.GetKeyDown(KeyCode.S):
            Save()
//flatten
        if Input.GetKeyDown(KeyCode.F):
            Flatten()
            
//change layer
        if Input.GetKeyDown(KeyCode.Alpha1):
            currentLayer = 0
        if Input.GetKeyDown(KeyCode.Alpha2):
            currentLayer = 1
        if Input.GetKeyDown(KeyCode.Alpha3):
            currentLayer = 2

    def NextFrame():
        if frame < maxFrames:
            frame = frame + frameSkip
        else:
            frame = 0
            
    def PreviousFrame():
            if frame > 0:
                frame = frame - frameSkip
            else:
                frame = maxFrames
                
    def PlayButton():
        if playing == false:
            StartCoroutine(Play())
        else:
            Stop()
            
    def Undo():
        if currentLine != null and layers.GetChild(currentLayer).GetChild(frame).childCount > 0:
            layers.GetChild(currentLayer).GetChild(frame).GetChild(i-1).gameObject.SetActive(false)
            layers.GetChild(currentLayer).GetChild(frame).GetChild(i-1).transform.parent = undoLayers.GetChild(currentLayer).GetChild(frame)
            i--
            
    def Redo():
        if currentLine != null and undoLayers.GetChild(currentLayer).GetChild(frame).childCount > 0:
            undoLayers.GetChild(currentLayer).GetChild(frame).GetChild(undoLayers.GetChild(currentLayer).GetChild(frame).childCount-1).gameObject.SetActive(true)
            undoLayers.GetChild(currentLayer).GetChild(frame).GetChild(undoLayers.GetChild(currentLayer).GetChild(frame).childCount-1).transform.parent = layers.GetChild(currentLayer).GetChild(frame)
            i++

    def Play() as IEnumerator:
        playing = true
        fps = 24/frameSkip
        currentFrame = frame
        if returnToFrameAfterPlay == true:
            frame = 0
        while frame < maxFrames:
            yield WaitForSeconds(1.0f/fps)
            frame = frame + frameSkip
        if frame >= maxFrames:
            frame = 0
            StartCoroutine(Play())

    def Stop():
        StopAllCoroutines()
        playing = false
        if returnToFrameAfterPlay == true:
            frame = currentFrame

    def RemoveFrame():
        if maxFrames > 0:
            maxFrames = maxFrames - frameSkip

    def AddFrame():
        currentFrame = frame
        maxFrames = maxFrames + frameSkip
                    
        layerIndex as int = 0
        while layerIndex < layers.childCount:
            frame = currentFrame
            while frame < maxFrames+1:
                frameParent as GameObject = GameObject("frame" + frame)
                frameParent.transform.parent = layers.GetChild(layerIndex)
                undoFrameParent as GameObject = GameObject("undoFrame" + frame)
                undoFrameParent.transform.parent = undoLayers.GetChild(layerIndex)
                frame++
            layerIndex++
            
        if frame >= maxFrames:
            frame = currentFrame
                    
                    
    def FrameSkipAdd():
        frameSkip++
        
    def FrameSkipSubtract():
        if frameSkip > 1:
            frameSkip--
    
    def DoubleFps():
        fps = fps*2
    
    def HalveFps():
        fps = fps/2
    
    def Flatten():
        frame = 0
        transform.position.x = 0
        while frame < maxFrames+1:
            transform.position.x = frame*20
    
    def Save():
        print("save")
        currentFrame = frame
        frame = 0
        transform.position.x = 0
        
        while frame < maxFrames+1:
            
            transform.position.x = frame*20
            
            outputCamera.targetTexture = renderTexture
            outputCamera.Render()
            RenderTexture.active = renderTexture
            tex = Texture2D(1920,1080, TextureFormat.RGB24, false) //TextureFormat.ARGB32
            tex.ReadPixels(Rect(0, 0, 1920,1080), 0, 0)
#            RenderTexture.active = null
            outputCamera.targetTexture = null
            
            bytes = tex.EncodeToPNG()
            File.WriteAllBytes(System.IO.Directory.GetCurrentDirectory() + "/Assets/Export/" + frame + ".png", bytes)
            
            frame = frame + frameSkip
        if frame >= maxFrames:
            frame = currentFrame




