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

    public static def Run(command as string, parameters as (string)):
        print("running command: " + command)

        type as Type = instance.GetType()
        method as MethodInfo = type.GetMethod(command)
        method.Invoke(instance, parameters)

    public static def GetMethodNames() as List of string:
        type as Type = instance.GetType()
        methodInfos = type.GetMethods(BindingFlags.Public|BindingFlags.Instance|BindingFlags.DeclaredOnly)
        methodNames = List of string()
        for methodInfo in methodInfos:
            methodNames.Add(methodInfo.Name)
        methodNames.Sort()

        return methodNames


    public def Test():
        print("test")

