﻿import UnityEngine
import System.Collections
import System.Reflection
import System

class CanvasManager (MonoBehaviour): 
    
    public static instance as CanvasManager
    public static currentCanvas as AnimationCanvas
    public canvasPrefab as GameObject
    public canvases as List of AnimationCanvas

    def Awake():
        instance = self
        canvases = List of AnimationCanvas()


    static def CreateCanvas(width as int, height as int, animationFrames as int, fps as int) as AnimationCanvas:
        newCanvasInstance = Instantiate(instance.canvasPrefab)
        newCanvasInstance.transform.SetParent(instance.transform)
        newCanvasInstance.transform.localPosition = Vector3.zero

        newCanvas = newCanvasInstance.GetComponent(AnimationCanvas)
        instance.canvases.Add(newCanvas)
        SelectCanvas(newCanvas)

        newCanvas.frameSize = Vector2(width, height)
        blankFrame = Texture2D(width, height, TextureFormat.ARGB32, false)
        blankFrameColors = array(Color, blankFrame.GetPixels().Length)
        for color in blankFrameColors:
            color = Color.clear
        blankFrame.SetPixels(blankFrameColors)
        blankFrame.Apply()

        blankFrame.filterMode = FilterMode.Point
        newCanvas.frames = List of Texture2D()
        newCanvas.fps = fps

        for i in range(animationFrames):
            newCanvas.frames.Add(blankFrame)

        newCanvas.currentFrame = newCanvas.frames[0]
        newCanvas.canvas.mainTexture = newCanvas.currentFrame

        newCanvas.canvasSize.y = newCanvas.transform.GetComponent(RectTransform).sizeDelta.y
        newCanvas.canvasSize.x = newCanvas.canvasSize.y * (width cast single / height cast single)
        newCanvas.transform.GetComponent(RectTransform).sizeDelta.x = newCanvas.canvasSize.x



        return newCanvas

    static def SelectCanvas(canvasToSelect as AnimationCanvas):
        for c in instance.canvases:
            if c == canvasToSelect:
                c.gameObject.SetActive(true)
                currentCanvas = c
            else:
                c.gameObject.SetActive(false)

    static def SelectCanvas(canvasIndex as int):
        for c in instance.canvases:
            c.gameObject.SetActive(false)

        currentCanvas = instance.canvases[canvasIndex]
        currentCanvas.gameObject.SetActive(true)