import UnityEngine
import System.Collections
import System.Reflection
import System.IO
import System


class Commands (MonoBehaviour): 
    
    public static instance as Commands


    def Awake():
        instance = self


    public static def Run(command as string):
        Commands.Run(command, array(string, 0))

    public static def Run(command as string, args as (string)):
        print("running command: " + command)

        method as MethodInfo = instance.GetType().GetMethod(command)
        parameters as (duck) = args

        try:
            instance.StartCoroutine(method.Name, parameters)
        except e:
            print(e)

    public static def GetMethodNames() as List of string:
        type as Type = instance.GetType()
        methodInfos = type.GetMethods(BindingFlags.Public|BindingFlags.Instance|BindingFlags.DeclaredOnly)
        methodNames = List of string()
        for methodInfo in methodInfos:
            methodNames.Add(methodInfo.Name)
        methodNames.Sort()

        return methodNames


    def Test():
        print("test")

    def CreateCanvas(parameters as (object)):
        width = (64 if parameters.Length == 0 or parameters[0] == "" else parameters[0])
        height = (64 if parameters.Length <= 1 or parameters[0] == "" else parameters[1])
        frameAmount = (1 if parameters.Length <= 2 or parameters[0] == "" else parameters[2])
        fps = (24 if parameters.Length <= 3 or parameters[0] == "" else parameters[3])

        CanvasManager.CreateCanvas(width, height, frameAmount, fps)

    def SelectColor(parameters as (object)):
        r = (0 if parameters.Length == 0 else parameters[0])
        g = (0 if parameters.Length <= 1 else parameters[1])
        b = (0 if parameters.Length <= 2 else parameters[2])
        a = (1 if parameters.Length <= 3 else parameters[3])

        print(r+" "+g+" "+b)
        # Tools.SelectColor(Color(r,g,b,a))

    def LoadFile(parameters as (object)):
        print("loading...." + parameters.Length)

        for parameter in parameters:
            filePath = parameter.ToString()
            print("trying to load: " + filePath)
            if File.Exists(filePath):

                if filePath.Substring(filePath.Length-4) == ".png":
                    fileData = File.ReadAllBytes(filePath)
                    texture as Texture2D = Texture2D(0, 0)
                    texture.filterMode = FilterMode.Point
                    texture.LoadImage(fileData) //this will auto-resize the texture dimensions.
                    
                    animationCanvas = CanvasManager.CreateCanvas(texture.width, texture.height, 1, 24)
                    animationCanvas.frames[0] = texture
                    animationCanvas.GoToFrame(0)

    def SaveFile(parameters as (object)):
        if CanvasManager.currentCanvas != null:
            filePath = parameters[0].ToString()
            bytes = CanvasManager.currentCanvas.frames[0].EncodeToPNG()
            File.WriteAllBytes(filePath, bytes)
            print("saved to file: " + filePath)