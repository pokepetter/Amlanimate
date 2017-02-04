import UnityEngine
import System.Collections
import System.Reflection
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

        instance.StartCoroutine(method.Name, parameters)


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

    def CreateProject(parameters as (object)):
        width as int = (64 if parameters.Length == 0 else parameters[0])
        print(width)