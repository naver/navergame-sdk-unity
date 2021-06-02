public static class GLinkDelegate
{
    public delegate void SdkOpenedDelegate();
    public delegate void SdkClosedDelegate();
    public delegate void SdkCallScheme(string yourSchemeAction);
    
    public static event SdkOpenedDelegate sdkOpenedEvent;
    public static event SdkClosedDelegate sdkClosedEvent;
    public static event SdkCallScheme sdkCallSchemeEvent;
    
    
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

    public static void _callSdkScheme(string scheme)
    {
        if (sdkCallSchemeEvent != null)
        {
            sdkCallSchemeEvent(scheme);
        }
    }
    

}
