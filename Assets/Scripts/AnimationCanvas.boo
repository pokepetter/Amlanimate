import UnityEngine
import System.Collections
import System.IO
import UnityEngine.UI
import UnityEngine.EventSystems

class AnimationCanvas (MonoBehaviour, IPointerUpHandler, IPointerDownHandler, IDragHandler): 

    public projectName as string
    public canvas as Material
    public color as Color32 = Color.black
    public brush as Texture2D
    public frames as List of Texture2D
    public currentFrame as Texture2D
    public cursor as Transform
    public pixelPosition as Vector2
    # public pixelPositionText as Text
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

    private xPos as int
    private ypos as int
    private opacity as single

    private newColor as Color32
            

    def OnDrag(eventData as PointerEventData):
        RectTransformUtility.ScreenPointToLocalPointInRectangle(GetComponent(RectTransform), eventData.position, eventData.pressEventCamera, mouseLocalPosition)
        if Input.GetMouseButton(0):
            pixelPosition = Vector2(((mouseLocalPosition.x / canvasSize.x) + 0.5f) * frameSize.x, ((mouseLocalPosition.y / canvasSize.y) + 0.5f) * frameSize.y)
            # pixelPositionText.text = pixelPosition.ToString()
            if lastPosition == -Vector2.one:
                lastPosition = pixelPosition
            DrawLine(lastPosition.x, lastPosition.y, pixelPosition.x, pixelPosition.y)
            lastPosition = pixelPosition
            currentFrame.Apply()


    def OnPointerDown(eventData as PointerEventData):
        RectTransformUtility.ScreenPointToLocalPointInRectangle(GetComponent(RectTransform), eventData.position, eventData.pressEventCamera, mouseLocalPosition)
        # indicator.SetFrameMarker(true)
        if Input.GetMouseButtonDown(0):
            pixelPosition = Vector2(((mouseLocalPosition.x / canvasSize.x) + 0.5f) * frameSize.x, ((mouseLocalPosition.y / canvasSize.y) + 0.5f) * frameSize.y)
            # pixelPositionText.text = pixelPosition.ToString()
            if lastPosition == -Vector2.one:
                lastPosition = pixelPosition
            DrawLine(lastPosition.x, lastPosition.y, pixelPosition.x, pixelPosition.y)
            lastPosition = pixelPosition
            currentFrame.Apply()     


    def OnPointerUp(eventData as PointerEventData):
        lastPosition = -Vector2.one

        //add icon to show if frame has been drawing on
        # if currentFrame != blankFrame:
        #   clone = Instantiate(keyFrameIcon)
        #   clone.transform.parent = frameParent
        #   clone.transform.localPosition.x = x


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
            zoom += Input.GetAxis("Mouse ScrollWheel") / 2
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
     
        halfWidth = brush.width /2
        halfHeight = brush.height /2

        for y in range(brush.height):
            for x in range(brush.width):
                xPos = startX+x-halfWidth
                yPos = startY+y-halfHeight
                color = brush.GetPixel(x,y).grayscale * Palette.currentColor
                currentFrame.SetPixel(xPos, yPos, color)

        # color = ((currentColor * (1 - opacity)) + (newColor * opacity)) //maybe handle transparency like this?
        if (differenceX > differenceY):
            fraction = differenceY - (differenceX >> 1)
            while startX != endX:
                if fraction >= 0:
                    startY += stepY
                    fraction -= differenceX
                startX += stepX
                fraction += differenceY
                
                for y in range(brush.height):
                    for x in range(brush.width):
                        xPos = startX+x-halfWidth
                        yPos = startY+y-halfHeight
                        color = brush.GetPixel(x,y).grayscale * Palette.currentColor
                        currentFrame.SetPixel(xPos, yPos, color)
        else:
            fraction = differenceX - (differenceY >> 1)
            while startY != endY:
                if fraction >= 0:
                    startX += stepX
                    fraction -= differenceY
                startY += stepY
                fraction += differenceX

                for y in range(brush.height):
                    for x in range(brush.width):
                        xPos = startX+x-halfWidth
                        yPos = startY+y-halfHeight
                        color = brush.GetPixel(x,y).grayscale * Palette.currentColor
                        currentFrame.SetPixel(xPos, yPos, color)
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




