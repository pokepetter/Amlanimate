﻿import UnityEngine
import System.Collections
import System.IO
import UnityEngine.UI
import UnityEngine.EventSystems

class Amseq (MonoBehaviour, IPointerUpHandler, IPointerDownHandler, IDragHandler): 

    public canvas as Material
    public color as Color32 = Color.black
    public frames as List of Texture2D
    public currentFrame as Texture2D
    public cursor as Transform
    public pixelPosition as Vector2
    public pixelPositionText as Text
    private mouseLocalPosition as Vector2
    private lastPosition as Vector2 = -Vector2.one
    public undoFrame as (Color)
    public indicator as Indicator

    public fps as single = 12
    public frameTime as single

    public frameSize as Vector2
    public canvasSize as Vector2
    public zoom as single = 1f
    public image as Image

    def Awake():
        frames = List of Texture2D()
        
        CreateProject(120)
        canvas.mainTexture = currentFrame
        canvasSize.y = transform.GetComponent(RectTransform).sizeDelta.y
        canvasSize.x = canvasSize.y * (frameSize.x / frameSize.y)

    def BlankFrame() as Texture2D:
        blankFrame = Texture2D(frameSize.x, frameSize.y, TextureFormat.ARGB32, false)
        # texColors = array(Color32, frameSize.x * frameSize.y)
        # for c in texColors:
        #     c = Color.red
        # blankFrame.SetPixels32(texColors)
        # blankFrame.Apply()
        return blankFrame


    def CreateProject(animationFrames as int):
        blankFrame = BlankFrame()
        for i in range(animationFrames):
            frames.Add(BlankFrame())
        currentFrame = frames[0]
            
    def OnDrag(eventData as PointerEventData):
        RectTransformUtility.ScreenPointToLocalPointInRectangle(GetComponent(RectTransform), eventData.position, eventData.pressEventCamera, mouseLocalPosition)
        if Input.GetMouseButton(0):
            pixelPosition = Vector2(((mouseLocalPosition.x / canvasSize.x) + 0.5f) * frameSize.x, ((mouseLocalPosition.y / canvasSize.y) + 0.5f) * frameSize.y)
            pixelPositionText.text = pixelPosition.ToString()
            if lastPosition == -Vector2.one:
                lastPosition = pixelPosition
            DrawLine(lastPosition.x, lastPosition.y, pixelPosition.x, pixelPosition.y)
            lastPosition = pixelPosition
            currentFrame.Apply()

    def OnPointerDown(eventData as PointerEventData):
        print("down")
        RectTransformUtility.ScreenPointToLocalPointInRectangle(GetComponent(RectTransform), eventData.position, eventData.pressEventCamera, mouseLocalPosition)
        indicator.SetFrameMarker(true)          

    def OnPointerUp(eventData as PointerEventData):
        lastPosition = -Vector2.one

    def Update():
        //undo
        if Input.GetMouseButtonDown(0):
            undoFrame = currentFrame.GetPixels()

        if Input.GetKey(KeyCode.LeftShift) and Input.GetKeyDown(KeyCode.Z):
            print("undo")
            # currentFrame = undoFrame
            currentFrame.SetPixels(undoFrame, 0)
            currentFrame.Apply()

        if Input.GetAxis("Mouse ScrollWheel") != 0:
            # if transform.localScale.x > 0.1f and transform.localScale.x < 2f:
            zoom += Input.GetAxis("Mouse ScrollWheel")
            zoom = Mathf.Clamp(zoom, 0.1f, 2f)
        transform.localScale = Vector3.Lerp(transform.localScale, Vector3.one * zoom, Time.fixedDeltaTime * 10)

        frameTime = 1f / fps

    def GoToFrame(frame as int):
        
        if frames[frame] != null:
            currentFrame = frames[frame]
            print("got to frame: " + frame)
        else:
            i = frame
            while i > 0:
                if frames[i] != null:
                    currentFrame = frames[i]
                    print("got to frame: " + i)
                i--

        canvas.SetTexture("_MainTex", currentFrame)
        image.enabled = false
        image.enabled = true


    # def Pen():
    #     currentTool = tool.pen
        
    # def Eraser():
    #     currentTool = tool.eraser
    
    # def Clear():
    #     pass
        
    # def Move():
    #     currentTool = tool.move
    #     if pan == true:
    #         pan = false
    #     else:
    #         pan = true

    def DrawLine(startX as int, startY as int, endX as int, endY as int):
        differenceX = endX - startX
        differenceY = endY - startY
        stepX as int
        stepY as int
     
        if differenceY < 0:
            differenceY = -differenceY 
            stepY = -1
        else:
            stepY = 1
        if differenceX < 0:
            differenceX = -differenceX
            stepX = -1
        else: 
            stepX = 1
        differenceY <<= 1
        differenceX <<= 1
     
        currentFrame.SetPixel(startX, startY, color)
        if (differenceX > differenceY):
            fraction = differenceY - (differenceX >> 1)
            while startX != endX:
                if fraction >= 0:
                    startY += stepY
                    fraction -= differenceX
                startX += stepX
                fraction += differenceY
                currentFrame.SetPixel(startX, startY, color)
        else:
            fraction = differenceX - (differenceY >> 1)
            while startY != endY:
                if fraction >= 0:
                    startX += stepX
                    fraction -= differenceY
                startY += stepY
                fraction += differenceX
                currentFrame.SetPixel(startX, startY, color)
# //toggle eraser
#         if Input.GetMouseButtonDown(1):
#             tempColor as Color = currentColor
#             currentColor = Color.white
                
#         if Input.GetMouseButtonUp(1):
#             currentColor = tempColor

# //pan
#         if Input.GetKeyDown(KeyCode.Space):
#             pan = true
            
#         if Input.GetKeyUp(KeyCode.Space):
#             pan = false
#             border.parent = transform
        
#         if Input.GetMouseButtonDown(0) and pan == true and currentTool == tool.move:
#             border.parent = null
#             startPan as Vector3 = Camera.main.ScreenToWorldPoint(Vector3(Input.mousePosition.x, Input.mousePosition.y, 10))
#             transform.position = startPan
# #        if Input.GetMouseButtonUp(0) and pan == false:

# //zoom  
#         Camera.main.orthographicSize -= Input.GetAxis("Mouse3")
#         canvasParent.localScale -= Vector3.one * Input.GetAxis("Mouse3") /5.4
#         if Input.GetMouseButtonDown(2):
#             Camera.main.orthographicSize = 5.4
#             canvasParent.localScale = Vector3.one
        

# //undo
#         if Input.GetKeyDown(KeyCode.Z):
#             Undo()
            
            
#         elif Input.GetKeyDown(KeyCode.Z):
#             print("nothing to undo")
# //redo
#         if Input.GetKeyDown(KeyCode.X):
#             Redo()

# //frames
#         if Input.GetButtonDown("NextFrame"):
#             NextFrame()

#         if Input.GetButtonDown("PreviousFrame"):
#             PreviousFrame()

#         frameCounter.text = frame.ToString()
#         maxFramesCounter.text = maxFrames.ToString()
#         transform.position.x = frame*20
        
#         fpsCounter.text = fps.ToString()
#         frameSkipCounter.text = frameSkip.ToString()

# //playback
#         if playing == false:
#             if Input.GetButtonDown("Play"):
#                 StartCoroutine(Play())
#                 playing = true


#         if playing == true:
#             if Input.GetButtonUp("Play"):
#                 StopAllCoroutines()
#                 Stop()
#                 playing = false
                
# //save
#         if Input.GetKeyDown(KeyCode.S):
#             Save()
# //flatten
#         if Input.GetKeyDown(KeyCode.F):
#             Flatten()
            
# //change layer
#         if Input.GetKeyDown(KeyCode.Alpha1):
#             currentLayer = 0
#         if Input.GetKeyDown(KeyCode.Alpha2):
#             currentLayer = 1
#         if Input.GetKeyDown(KeyCode.Alpha3):
#             currentLayer = 2

#     def NextFrame():
#         if frame < maxFrames:
#             frame = frame + frameSkip
#         else:
#             frame = 0
            
#     def PreviousFrame():
#             if frame > 0:
#                 frame = frame - frameSkip
#             else:
#                 frame = maxFrames
                
#     def PlayButton():
#         if playing == false:
#             StartCoroutine(Play())
#         else:
#             Stop()
            
#     def Undo():
#         if currentLine != null and layers.GetChild(currentLayer).GetChild(frame).childCount > 0:
#             layers.GetChild(currentLayer).GetChild(frame).GetChild(i-1).gameObject.SetActive(false)
#             layers.GetChild(currentLayer).GetChild(frame).GetChild(i-1).transform.parent = undoLayers.GetChild(currentLayer).GetChild(frame)
#             i--
            
#     def Redo():
#         if currentLine != null and undoLayers.GetChild(currentLayer).GetChild(frame).childCount > 0:
#             undoLayers.GetChild(currentLayer).GetChild(frame).GetChild(undoLayers.GetChild(currentLayer).GetChild(frame).childCount-1).gameObject.SetActive(true)
#             undoLayers.GetChild(currentLayer).GetChild(frame).GetChild(undoLayers.GetChild(currentLayer).GetChild(frame).childCount-1).transform.parent = layers.GetChild(currentLayer).GetChild(frame)
#             i++

#     def Play() as IEnumerator:
#         playing = true
#         fps = 24/frameSkip
#         currentFrame = frame
#         if returnToFrameAfterPlay == true:
#             frame = 0
#         while frame < maxFrames:
#             yield WaitForSeconds(1.0f/fps)
#             frame = frame + frameSkip
#         if frame >= maxFrames:
#             frame = 0
#             StartCoroutine(Play())

#     def Stop():
#         StopAllCoroutines()
#         playing = false
#         if returnToFrameAfterPlay == true:
#             frame = currentFrame

#     def RemoveFrame():
#         if maxFrames > 0:
#             maxFrames = maxFrames - frameSkip

#     def AddFrame():
#         currentFrame = frame
#         maxFrames = maxFrames + frameSkip
                    
#         layerIndex as int = 0
#         while layerIndex < layers.childCount:
#             frame = currentFrame
#             while frame < maxFrames+1:
#                 frameParent as GameObject = GameObject("frame" + frame)
#                 frameParent.transform.parent = layers.GetChild(layerIndex)
#                 undoFrameParent as GameObject = GameObject("undoFrame" + frame)
#                 undoFrameParent.transform.parent = undoLayers.GetChild(layerIndex)
#                 frame++
#             layerIndex++
            
#         if frame >= maxFrames:
#             frame = currentFrame
                    
                    
#     def FrameSkipAdd():
#         frameSkip++
        
#     def FrameSkipSubtract():
#         if frameSkip > 1:
#             frameSkip--
    
#     def DoubleFps():
#         fps = fps*2
    
#     def HalveFps():
#         fps = fps/2
    
#     def Flatten():
#         frame = 0
#         transform.position.x = 0
#         while frame < maxFrames+1:
#             transform.position.x = frame*20
    
#     def Save():
#         print("save")
#         currentFrame = frame
#         frame = 0
#         transform.position.x = 0
        
#         while frame < maxFrames+1:
            
#             transform.position.x = frame*20
            
#             outputCamera.targetTexture = renderTexture
#             outputCamera.Render()
#             RenderTexture.active = renderTexture
#             tex = Texture2D(1920,1080, TextureFormat.RGB24, false) //TextureFormat.ARGB32
#             tex.ReadPixels(Rect(0, 0, 1920,1080), 0, 0)
# #            RenderTexture.active = null
#             outputCamera.targetTexture = null
            
#             bytes = tex.EncodeToPNG()
#             File.WriteAllBytes(System.IO.Directory.GetCurrentDirectory() + "/Assets/Export/" + frame + ".png", bytes)
            
#             frame = frame + frameSkip
#         if frame >= maxFrames:
#             frame = currentFrame




