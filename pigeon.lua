--name pigeon
--desc run in lobby
--author sekc

panorama.executeScript([[
    model = $.GetContextPanel().GetChild(0).FindChildInLayoutFile( 'JsMainmenu_Vanity' );
    model.visible = true;
    model.actualyoffset = 100
    model.SetScene("resource/ui/econ/ItemModelPanelManifest_Panorama.res", "models/player/custom_player/legacy/ctm_sas.mdl", false)
    model.SetSceneModel("models/pigeon.mdl")
]], "CSGOMainMenu")