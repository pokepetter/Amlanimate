import UnityEngine
import System.Collections
import System
 
class StartupParameterHandler (MonoBehaviour): 
 
    def Awake():
        Commands.Run("LoadFile", Environment.GetCommandLineArgs())