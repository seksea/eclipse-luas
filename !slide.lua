--name slide
--desc He was a boy She was a girl Can I make it any more obvious? He was a punk She did ballet What more can I say? He wanted her She'd never tell Secretly she wanted him as well But all of her friends Stuck up their nose They had a problem with his baggy clothes He was a skater boy She said, "See you later, boy" He wasn't good enough for her he had a pretty face But her head was up in space She needed to come back down to earth Five years from now She sits at home Feeding the baby, she's all alone She turns on TV Guess who she sees Skater boy rockin' up MTV She calls up her friends They already know And they've all got tickets to see his show She tags along And stands in the crowd Looks up at the man that she turned down He was a skater boy She said, "See you later, boy" He wasn't good enough for her Now he's a super star Slammin' on his guitar Does your pretty face see what he's worth? He was a skater boy She said, "See you later, boy" He wasn't good enough for her Now he's a super star Slammin' on his guitar Does your pretty face see what he's worth? Sorry, girl, but you missed out Well, tough, luck that boy's mine now  e are more than just good friends This is how the story ends Too bad that you couldn't see See the man that boy could be There is more that meets the eye I see the soul that is inside He's just a boy And I'm just a girl Can I make it any more obvious? We are in love Haven't you heard How we rock each other's world I'm with the skater boy I said, "See you later, boy" I'll be back stage after the show I'll be at a studio Singing the song we wrote About a girl you used to know I'm with the skater boy I said, "See you later, boy" I'll be back stage after the show I'll be at a studio Singing the song we wrote About a girl you used to know
--author winston, sekc

-- this script starts with an "!" as scripts are ran in alphebetical order,
-- and this needs to run before edgebug and legitbhop or else they will not work properly
IN_FORWARD  = 8;
IN_BACK     = 16;
IN_MOVELEFT = 512;
IN_MOVERIGHT= 1024;

MOVETYPE_NOCLIP = 8;
MOVETYPE_LADDER = 9;

function onCreateMove(cmd)
    local localPlayer = entitylist.getEntity(entitylist.getLocalPlayer())
    if not (localPlayer:sane() and localPlayer:alive()) then return end

    if localPlayer:movetype() == MOVETYPE_LADDER or localPlayer:movetype() == MOVETYPE_NOCLIP then return end
    cmd.buttons = bit.band(cmd.buttons, bit.bnot(IN_BACK))
    cmd.buttons = bit.band(cmd.buttons, bit.bnot(IN_FORWARD))
    cmd.buttons = bit.band(cmd.buttons, bit.bnot(IN_MOVELEFT))
    cmd.buttons = bit.band(cmd.buttons, bit.bnot(IN_MOVERIGHT))
    
    if cmd.forwardmove > 0 then
        cmd.buttons = bit.bor(cmd.buttons, IN_BACK)
    elseif cmd.forwardmove < 0 then
        cmd.buttons = bit.bor(cmd.buttons, IN_FORWARD)
    end

    if cmd.sidemove > 0 then
        cmd.buttons = bit.bor(cmd.buttons, IN_MOVELEFT)
    elseif cmd.sidemove < 0 then
        cmd.buttons = bit.bor(cmd.buttons, IN_MOVERIGHT)
    end

    eclipse.setCmd(cmd)
end

eclipse.registerHook("createMove", onCreateMove)