using UnityEngine;
using System;
using System.Collections;
using System.Text.RegularExpressions;
using System.IO;

public class SampleBehaviour : MonoBehaviour {

    [Header("NAVER GAME Lounge ID")]
    public string LoungeId = "naver_game_4developer";

	[Header("NAVER GAME ClientId")]
	public string NaverLoginClientId = "UKvNABLDsyEJusJGsXL2";
	
	[Header("NAVER GAME ClientSecret")]
	public string NaverLoginClientSecret = "rK4suc_Qd0";
	
    void Start()
    {
        GLink.sharedInstance().init(LoungeId, NaverLoginClientId, NaverLoginClientSecret);
        GLinkDelegate.sdkCallInGameMenuCode += code =>
        {
	        GLink.sharedInstance().terminateSdk();
	        Debug.Log("CallInGameMenuCode : " + code);	
        };
    }

    public void OnClickGlinkButton () {
		Debug.Log("click!");
		GLink.sharedInstance().executeBoard(1);
    }
    
}


