﻿import UnityEngine

class ToggleButton (MonoBehaviour): 
    
    public toggledGraphic as Transform
    private button as Button
    public targetScale as Vector2
    public hideOnAwake as bool
    private elapsedTime as single
    private t as single


    def Awake():
        if toggledGraphic != null:
            button = GetComponent(Button)
            button.onClick.AddListener({Toggle()})

            if hideOnAwake:
                toggledGraphic.gameObject.SetActive(false)
                toggledGraphic.localPosition = Vector2.zero
                toggledGraphic.localScale = Vector2.zero
                targetScale = Vector2.zero



    public def Toggle():
        if toggledGraphic != null:
            if not toggledGraphic.gameObject.activeSelf:
                StartCoroutine(ScaleRoutine(Vector2.one))
            else:
                StartCoroutine(ScaleRoutine(Vector2.zero))


    private def ScaleRoutine(targetScale as Vector2) as IEnumerator:
        elapsedTime = 0f
        t = 0f
        startValue = toggledGraphic.localScale
        if targetScale != Vector2.zero:
        	toggledGraphic.gameObject.SetActive(true)

        while elapsedTime < 0.1f:
            yield WaitForSeconds(0.01f)
            elapsedTime += 0.01f
            t = elapsedTime/0.1f
            t = Mathf.Sin(t * Mathf.PI * 0.5f)
            toggledGraphic.localScale = Vector2.Lerp(startValue, targetScale, t)
        toggledGraphic.localScale = targetScale

        if targetScale == Vector2.zero:
        	toggledGraphic.gameObject.SetActive(false)
        yield