public static class GLinkDelegate
{
    public delegate void SdkOpenedDelegate();
    public delegate void SdkClosedDelegate();
    public delegate void SdkCallInGameMenuCode(string InGameMenuCode);
    
    public static event SdkOpenedDelegate sdkOpenedEvent;
    public static event SdkClosedDelegate sdkClosedEvent;
    public static event SdkCallInGameMenuCode sdkCallInGameMenuCode;
    
    
    public static void _callSdkOpened()
    {
        if (sdkOpenedEvent != null)
        {
            sdkOpenedEvent();
        }
    }
    public static void _callSdkClosed()
    {
        if (sdkClosedEvent != null)
        {
            sdkClosedEvent();
        }
    }

    public static void _callSdkInGameMenuCode(string InGameMenuCode)
    {
        if (sdkCallInGameMenuCode != null)
        {
            sdkCallInGameMenuCode(InGameMenuCode);
        }
    }
    

}
