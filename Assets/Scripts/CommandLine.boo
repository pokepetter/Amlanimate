import UnityEngine
import UnityEngine.UI

class CommandLine (MonoBehaviour): 
    
    public toggledGraphic as Transform
    public panel as Image
    public suggestedWordButton as GameObject
    public text as Text
    public methodNameToRun as string

    public canvas as Transform

    private availableMethods as List of string

    public targetScale as Vector2
    private elapsedTime as single
    private t as single

    def Start():
        availableMethods = Commands.GetMethodNames()
        allButtons = canvas.GetComponentsInChildren(AutoButton)


    def Update():
        if Input.GetKey(KeyCode.LeftControl):
            if Input.GetKeyDown(KeyCode.F):
                print("search")
                Toggle()

            if Input.GetKeyDown(KeyCode.Backspace):
                methodNameToRun = ""
                text.text = methodNameToRun

        if Input.anyKeyDown:
            if toggledGraphic.gameObject.activeSelf and Input.inputString.Length == 1and char.IsLetter(Convert.ToChar(Input.inputString)):
                methodNameToRun += Input.inputString
                text.text = methodNameToRun

            for method in availableMethods:
                if method == methodNameToRun:
                    panel.color = Color(0.6, 0.8, 0.2)
                    break
                else:
                    panel.color = Color.white

        if Input.GetKeyDown(KeyCode.Backspace):
            if methodNameToRun.Length > 0:
            	methodNameToRun = methodNameToRun.TrimEnd(methodNameToRun[methodNameToRun.Length -1])
                //autocomplete
                # if suggestionList.Length > 0:
                # print("select button 0")

        if Input.GetKeyDown(KeyCode.Escape):
            if toggledGraphic.localScale.x > 0.9:
                Toggle()    

        if Input.GetKeyDown(KeyCode.Return) or Input.GetKeyDown(KeyCode.KeypadEnter):
            for method in availableMethods:
                if method == methodNameToRun:
                    Commands.Run(methodNameToRun)
                    methodNameToRun = ""
                    Toggle()
                    break

            previousCommand = methodNameToRun
            methodNameToRun = ""


    def UpdateList():
        if methodNameToRun != "":
            pass


    public def Toggle():
        if toggledGraphic.localScale.x < 0.9f:
            StartCoroutine(ScaleRoutine(Vector2.one))
        else:
            StartCoroutine(ScaleRoutine(Vector2.zero))


    private def ScaleRoutine(targetScale as Vector2) as IEnumerator:
        elapsedTime = 0f
        t = 0f
        startValue = toggledGraphic.localScale

        while elapsedTime < 0.1f:
            yield WaitForSeconds(0.01f)
            elapsedTime += 0.01f
            t = elapsedTime/0.1f
            t = Mathf.Sin(t * Mathf.PI * 0.5f)
            toggledGraphic.localScale = Vector2.Lerp(startValue, targetScale, t)
        toggledGraphic.localScale = targetScale

        yield