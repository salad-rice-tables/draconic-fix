-- Fill empty quest texts from Wiki batches P1/P3 (verbatim, stubs skipped).
-- Undo: 20261013_wiki_textfill3_undo.sql
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Excellent. This Unbending Potion should shore up the Felslate enough to hold the portal''s structure, and these Chaotic Spinel crystals should focus the portal''s magic nicely.

I will set the mo''arg to work posthaste.' WHERE `ID`=46238;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (46238,0,0,0,0,'Have you the necessary materials?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The path of the Daredevil is available to you if you dare.' WHERE `ID`=58297;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (58297,0,0,0,0,'Place the Faceless Mask of the Daredevil on the altar.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The treacherous path of the Burned Bridge will be available to you if you wish to tread it.' WHERE `ID`=58314;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (58314,0,0,0,0,'Place the Faceless Mask of the Burned Bridge on the altar.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The risks at the edges of your sanity will now manifest if you so choose to engage them.' WHERE `ID`=58316;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (58316,0,0,0,0,'Place the Faceless Mask of the Dark Imagination on the altar.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='As my madness and torment is not enough, feel free to invite even more pain in the future.' WHERE `ID`=58317;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (58317,0,0,0,0,'Place the Faceless Mask of the Pained on the altar.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Taking a step towards the Longest Night is already acknowledging the sanity you have lost. Do you risk the rest on such a fools errand?' WHERE `ID`=58318;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (58318,0,0,0,0,'Place the Faceless Mask of the Long Night on the altar.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The camera doesn''t lie, $n.

You are one stylish $c.' WHERE `ID`=76285;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (76285,0,0,0,0,'Focus on me and follow my directions.

I''ll make sure you look great.',0);
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (84672,0,0,0,0,'Toxic fumes? Nah, that''s just what Undermine smells like!',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Dat was pretty easy. We should do more!' WHERE `ID`=86156;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86156,0,0,0,0,'Did you check out the cave? No? Get goin'' then!',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Excellent. 

Now, we raise the dead.' WHERE `ID`=86182;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86182,0,0,0,0,'Well? Have you succeeded?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Well done, $n. Certainly a first.' WHERE `ID`=86183;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='There we go! Just what I was lookin'' for. Hope that wasn''t too hard for ya!' WHERE `ID`=86187;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86187,0,0,0,0,'How''d it go?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I get along fine with nerubians, but those things...

Those things scare me. Glad they''re gone. Phew!' WHERE `ID`=86189;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86189,0,0,0,0,'Did ya get ''em?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Give it a bit, $n. Can''t rush love!' WHERE `ID`=86194;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86194,0,0,0,0,'Have you got them smellin'' better?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Chicken soup is good for a lot of things. Dunno if the mouthwash''ll help though.

At least they''ll smell better?' WHERE `ID`=86272;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86272,0,0,0,0,'I got the pot simmerin''. All it needs is a few finishing touches.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Splendid. It was enjoyable to watch both the k''arroc and yourself flying around out there.

You are quite the accomplished rider, $n.' WHERE `ID`=86342;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You are reliable, as always.' WHERE `ID`=86348;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86348,0,0,0,0,'Do you have the essences?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Excellent. I shall take it from here.' WHERE `ID`=86349;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86349,0,0,0,0,'How fare your efforts?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='If ye need my help, I need yours first.' WHERE `ID`=86352;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='We''ve cut out the corruption here. In time, the land''ll recover.' WHERE `ID`=86354;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86354,0,0,0,0,'I don''t relish the kills, but it has to be done.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Good work! Full bellies ought to keep ''em happy enough.' WHERE `ID`=86357;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86357,0,0,0,0,'Have ye fed those ottuks yet?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='If you told a younger me I''d be teaching animals how to hunt, I''d have laughed you away.' WHERE `ID`=86360;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86360,0,0,0,0,'Is she hunting properly?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='My friend! I knew I could count on you. Please take these tokens for your effort.' WHERE `ID`=86363;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I knew you would be effective in this situation. I did not know it would be such a pleasure to watch you accomplish your task.' WHERE `ID`=86392;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86392,0,0,0,0,'Have you made a suitable display of dominance?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='She agreed?

Alleria listens to you, my champion. You are indeed our savior.' WHERE `ID`=86495;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Woah! I thought Rustol was gonna send through a gerbil or a can of peaches or somethin'' to test out the new teleporter, not an actual person.

But you''re only sizzlin'' a little bit! Fantastic.

Tell ya what. For doin'' us a solid and havin'' such little regard for your own personal safety, we''ll let ya use the teleporters free of charge whenever ya want.' WHERE `ID`=86535;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='What an excellent apprentice you are!' WHERE `ID`=86590;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86590,0,0,0,0,'Well? Have you gathered the essences?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I''m glad you were here, apprentice. I find wiping out all the plague in a creature quite unnerving. Feels very unhealthy.' WHERE `ID`=86592;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86592,0,0,0,0,'Have you jabbed the necrorays?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Well done. I have transferred the necrorays to the Atrium as per our quarantine procedures.' WHERE `ID`=86593;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Good work tagging those necrorays. We''ll be able tae keep a better eye on them this way.' WHERE `ID`=86601;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86601,0,0,0,0,'Have ye tagged those rays?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The Oasis will benefit greatly from your efforts. My thanks.' WHERE `ID`=86606;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86606,0,0,0,0,'Have you succeeded at your task?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='That was fast, $n! Faster than I go, these days. I''ll leave the speedin'' along to you.' WHERE `ID`=86607;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86607,0,0,0,0,'Have ye worn the thing out yet?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='That''s what I''m talkin'' about!

Now those bots''ll be able to work without bein'' hassled by all them nasty Black Blood monsters out there.' WHERE `ID`=86697;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86697,0,0,0,0,'Got any good news, kid?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You''ve been helpful so far. And in return, I''ll allow you to take part in making history on this discarded, broken corpse of a planet.' WHERE `ID`=86786;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Satiated in the blood of multitudes now and forever. For our ranks will be endless and consume the world.' WHERE `ID`=86801;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Renzi''s really been rackin'' up the recruits lately. You''re gonna have some competition!' WHERE `ID`=86934;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I must say, I underestimated you. It seems there''s more to you than just flailing around.' WHERE `ID`=86998;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86998,0,0,0,0,'Ah! So you''ve come crawling back after failing to defeat even my least competent followers?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='We''ve shown everyone that Undermine ain''t never bendin'' the knee to no one. And if they try to force us, they better be ready for a hell of a fight.

The future ain''t gonna be perfect--but if it''s ours to mess up, that''s good enough for me.' WHERE `ID`=87297;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (87297,0,0,0,0,'Heya, boss.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='It''s alright, $n. You are back. You''ve done well. Remember, this was just a memory of a vision.

While we will keep you safe from the past, the danger we are all in from the Void is still very real in the present.' WHERE `ID`=87328;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Ah, a note on ''special cargo.'' How delightfully subtle--about as discreet as a goblin''s pyrotechnics.

It seems the Tideborne are entangled in this mess, and we have little choice but to wade in after them. If that means diving into the depths, so be it.' WHERE `ID`=87392;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='It''s an unfortunate task, but the creatures did not belong here. They would have put any new researchers at risk.

Now to the actual problem.' WHERE `ID`=87399;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Perfect. This should get us inside the main building.' WHERE `ID`=87401;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='What was beyond those doors was a horror. To use the Light in such a manner...

Thank you. We will have this place scoured with flames before it is used again.' WHERE `ID`=87402;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='A success... Do you understand what this means, $n? We are no longer limited to the creatures we took with us. So long as we can find their untethered counterparts, we can remake any of K''aresh''s creatures. They will live again!' WHERE `ID`=87409;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='These are exquisite, and will do quite nicely for our research. Thank you.' WHERE `ID`=87412;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (87412,0,0,0,0,'Have you taken the photos I requested?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='How did it feel to be the first person to fly on the back of a k''arroc in a millennia?' WHERE `ID`=87415;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (87415,0,0,0,0,'How did the shield hold up?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Thank you for bringing all people of Khaz Algar a glimmer of hope.' WHERE `ID`=87417;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='There are fewer shadows in the world thanks to your efforts.' WHERE `ID`=87419;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (87419,0,0,0,0,'How goes your dangerous exploration?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You made some extraordinary efforts on some... unique requests. Your service to Undermine is appreciated by all.' WHERE `ID`=87422;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (87422,0,0,0,0,'Undermine is very strange to me. Still, when a friend asks for help... you help them.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='When Beledar darkened, what would they have built if they were in our place?

Your efforts continue to be of great service.' WHERE `ID`=87423;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (87423,0,0,0,0,'They don''t stop moving just because something doesn''t work. I admire that.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='How did you fare? Any new scars? Or new tales to tell?' WHERE `ID`=87424;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='No no, I''ve got it! Stand back!' WHERE `ID`=87455;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='These look to be in good shape considering how long we left them here.

Not sure if Fiona''s even still looking for these, but she''ll appreciate the uh... very late gesture.' WHERE `ID`=87456;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Acknowledging your nemesis is the first step towards their final defeat. Yet, they would not be a nemesis if they did not find infinite ways to face you again and again.' WHERE `ID`=88652;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (88652,0,0,0,0,'Place the Faceless Mask of the Nemesis on the altar.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Those''ll do. Nice work.' WHERE `ID`=88656;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (88656,0,0,0,0,'It''s nice to be helpin'' these critters rather than hunting ''em.

The angry elementals don''t count!',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I''m glad ye made it back here in one piece, and none too soon. Me an ol'' Fitz have been holding off these crazed talbuk attacks for what seems like ages.' WHERE `ID`=88657;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (88657,0,0,0,0,'How much you got? It''s one o'' the last things we need before we head back to K''aresh.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='We need to make sure the snakes are as comfortable as possible when we take ''em to K''aresh.

But, yikes. The smell o'' those plants. Fragrant indeed!' WHERE `ID`=88658;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (88658,0,0,0,0,'How many do you have? I canna tell. Your pack always looks so full.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Great! I''ll signal Ve''nari so she can send us one o'' her gods-forsaken portals an'' we''ll be on our way.' WHERE `ID`=88660;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (88660,0,0,0,0,'You got ''em?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='We could hear ye from here. How many lessons have ye had?' WHERE `ID`=88670;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (88670,0,0,0,0,'I''m certain you''re much better at playin'' that thing than me.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='How''d you carry ''em all? If I''d known, I would have given you some more o'' them portation tag thingies.' WHERE `ID`=88671;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (88671,0,0,0,0,'How goes the egg pilferin''?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='All o'' the snakes are fitting in better than we could possibly have imagined. This brings me so much hope for K''aresh.

Ye''ve done a great thing here, $n!' WHERE `ID`=88672;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (88672,0,0,0,0,'What an excitin'' time.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='A grim task, $n. But one that may bring a small measure of comfort to those that live.' WHERE `ID`=88701;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I hope you''re prepared to hunt, $n. This quarry is more elusive than most.' WHERE `ID`=88703;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Oh thank the light! I thought I''d be food for sure!

Can you free me from this thing?' WHERE `ID`=88704;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Make ready, $n. Soon, we will pay Xal''atath back for all she has done to us.' WHERE `ID`=88707;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Well fought, $n. But our task is not yet over.' WHERE `ID`=88769;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You may call upon this aid for any vision.' WHERE `ID`=88803;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Be prepared to face the wrath of your enemies should you don this mask.' WHERE `ID`=88903;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Well done, champion.

Our golems are coming back online, our soldiers are able to conjure and power their weapons again, and we are mobilizing for war.' WHERE `ID`=88919;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='This is quite the ensemble you''ve brought to my lands, $r.' WHERE `ID`=88920;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='<Name>, surely you remember my aunt, Vereesa Windrunner. You were with us at the ruins of Dalaran when her visions of the Void assaulting the Sunwell first manifested.

She and her Silver Covenant, what remains of the quel''dorei as they once were, will prove invaluable in the fight to come.

;Characters who did not complete the Visions of a Shadowed Sun questline:
Champion, this is Vereesa Windrunner. My aunt. She raised me in Silvermoon until she relocated to Dalaran.

She and her Silver Covenant, what remains of the quel''dorei as they once were, will prove invaluable in the fight to come.' WHERE `ID`=88922;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very well. The Void represents a threat to this world we cannot ignore.

I grow tired of yet another threat at the Sunwell that cannot be ignored.' WHERE `ID`=88923;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (88923,0,0,0,0,'Have you more to add?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I have no idea what the First Arcanist is referring to. We have been at peace for some time now.' WHERE `ID`=88928;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Thank you, $n.

Now let''s begin planning this city''s defense before it is too late. Again.' WHERE `ID`=88941;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Cultists? Xal''atath seems intent on undermining us at every turn.

We must be grateful she continues to underestimate your skills.

With the Nightborne ready, that means our forces are gathered. We will position ourselves and strategize how best to deploy our forces.

Thank you, champion.' WHERE `ID`=88942;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The work we have done here can ensure that, with what happened at Eco-Dome: Adani, we can rebuild K''aresh.

It will take time. So very much time. But I suppose that is the advantage of being immortal yes? Even if it takes tens of thousands of years, my home will be rebuilt.

Hopefully, I will be around to see it happen. I have a stasis pod with your name on it, should you have need of it.' WHERE `ID`=88976;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='A dog, a lynx, and now a ruined journal. Truly, I''ve seen lesser misfortunes in my day.

It seems the journal''s fate was sealed long before we laid eyes on it. It is quite beyond saving. Once again, my faith in anything other than arcane precision has proven... misplaced.' WHERE `ID`=88979;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Hmm. Not bad. For a novice.' WHERE `ID`=88988;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='What a remarkable story!

How ironic that the tale of Sai''alyo, the first of the Zur''ashar, was lost to time. Your efforts bring us closer to understanding this vital piece of our history.

Please, accept this keepsake as a mark of my gratitude for your dedication.

For now, I will delve deeper into our archives, uncovering relics that still long for discovery.

Return when the whispers of the world guide you back to me.' WHERE `ID`=88994;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Chase that paper!' WHERE `ID`=89024;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Chase that paper!' WHERE `ID`=89025;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Chase that paper!' WHERE `ID`=89026;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You want that to go? Have it your way!' WHERE `ID`=89027;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Compliments of the house! Take this to the nice Hobgoblin just across the way and pick yourself up somethin'' nice.' WHERE `ID`=89028;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='As always, your assistance is appreciated. What? I can''t drop puns every time, you know.' WHERE `ID`=89195;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Excellent. You show much talent for image capturing. Thank you.' WHERE `ID`=89213;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Thanks, $n. You are a leaf saver.' WHERE `ID`=89221;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (89221,0,0,0,0,'Have you fed the lapbugs yet?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Thank you again. These k''arrocs will do quite nicely.' WHERE `ID`=89238;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (89238,0,0,0,0,'How is the shrinking and collecting coming along?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You never disappoint, $n. Mostly. As promised, here is your cut.' WHERE `ID`=89242;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (89242,0,0,0,0,'How go your efforts?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You $n? Got something for you.' WHERE `ID`=89263;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Well done, my dear. We shall have the Haven sparkling in due time.' WHERE `ID`=89277;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (89277,0,0,0,0,'We need only a small quantity. Our spellwork is quite efficient.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Excellent choice.

I will have my valet send for them at once.' WHERE `ID`=89289;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You''ve bought us a moment of peace.

Rest well, but always keep your blade sharp.' WHERE `ID`=89295;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (89295,0,0,0,0,'Ready yourself soldier, the battle is still to come.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Wow, you bigger and taller than kobold friends. Hello Big-Tall, my name Skibbles!

Me hear you are very brave, Big-Tall. Skibbles want to be just like you! Talk-Rock say you here to help Skibbles.

You here to take Skibbles on an adventure?? Me always want to go on adventure! Dis gonna be best day ever!' WHERE `ID`=89317;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='My, look at Destien!

I don''t think he''s ever talked so much before. The nerubians must have left a strong positive impression on him indeed.

I can''t wait to hear what he''s learned by spending some time with you today. Who knows? Perhaps this is a small start to a better understanding between the two races.

Oh! The nerubian youngling, Threadis, has been eagerly awaiting you. They don''t speak yet, which is common for young nerubians, but they can still communicate using other methods.' WHERE `ID`=89319;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (89319,0,0,0,0,'My goodness! The nerubians certainly have an interesting society. The younglings seem to be very different than the Arathi children, even though they''re similar in their desire to play and get into trouble.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Would you look at Threadis! I know they are very proud of that little bot they built, so I''m glad they were able to bring it to a place where their talents are appreciated.

I''ll stay here and see if I can have a chat with Professor Neltik. Why don''t you take Kitzy? We''ll meet you in Dornogal when you''re finished!' WHERE `ID`=89320;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (89320,0,0,0,0,'My, this place is certainly different! It''s almost the complete opposite of the Weaver''s Lair. Not to mention all the colors... and smells.

It has been fun to watch the goblin children at play, though. They have more in common with the Arathi, kobold, and nerubian children than I would have imagined!

They''re certainly a handful...',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='We''re nearly prepared. Although I can''t help but wonder if Adarus'' reach exceeds his grasp.' WHERE `ID`=89325;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I knew we could count on you!' WHERE `ID`=89331;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (89331,0,0,0,0,'Be ready, the Sureki could attack at any moment!',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You learn quickly. Good. Untethered Space devours the foolish and unwise.' WHERE `ID`=89343;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Netherdeath is no more. Our exploration of Untethered Space can proceed. I knew you were the right person to help us in our endeavors, $n.

We would be honored if you would continue to work with us in our exploration.' WHERE `ID`=89345;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Let''s starting helping the bees get acclimated!' WHERE `ID`=89348;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`=';Renown 2
Your exemplary service hasn''t gone unnoticed, $n. I hope this reward serves you well.

;Renown 3 onwards
Your service has not gone unnoticed, $n. I hope this reward serves you well.' WHERE `ID`=89349;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Not everyone would go to such lengths for these creatures.

I''d like to give you something special, as thanks for your help. I I think think you y have more than proven you can be entrusted with this.

A hawkstrider egg. Not yet hatched, but there is a little one in there--wiggling. curious, and eager to meet the one who will raise it with love. Take care of it, and it will take good care of you in return.' WHERE `ID`=89385;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='These threads contain traces of potential epoch energy. To access their power we''ll need to infuse them into a stabilizing material, such as infinite bronze, in order to anchor them in place.

They''ll lose some of their potency, but at least they will be sufficient for our needs.' WHERE `ID`=89408;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Now that you have infinite bronze we can get you an artifact in order to properly carry out our tests.

Then you''ll have no problem living up to your own legend, $n.' WHERE `ID`=89409;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I can sense the power emanating from your artifact from here. Good.

I''ve also noted that it hasn''t fractured under the power load yet. Also good.

Let me just make a note of that for Moratari''s records. Very good.' WHERE `ID`=89412;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Well done, $n. Moratari will be overjoyed to see these new data points.' WHERE `ID`=89464;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (89464,0,0,0,0,'We need more fight data to complete our study, and time is running short.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Your name is on the minds of the people, and is shared around the fire. The greater your legend becomes, the more powerful your name will be. But does the power of one''s name eclipse that of the artifact they wield? This is the burning question.' WHERE `ID`=89465;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The sum strength of a group of timerunners armed with potent artifacts is greater than that of the individuals. Much greater than anticipated. Intriguing.' WHERE `ID`=89466;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The sum strength of a group of timerunners armed with potent artifacts is greater than that of the individuals. Much greater than anticipated. Intriguing.' WHERE `ID`=89467;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You have no idea how happy this will make Moratari.' WHERE `ID`=89468;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You have no idea how happy this will make Moratari.' WHERE `ID`=89469;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I asked for you help without tellin'' you about how my mother treated my brother and me. I don''t speak much about my family. I learned not to.

I still don''t understand why she was the way she was. Maybe somethin'' happened to her. Somethin'' that''d cause all dat pain... Maybe pain and chaos were all she knew herself.

But in de tribe, she inspired many--at least she can remain a mother to dem.' WHERE `ID`=89503;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Kan''sha''s been a long-time friend, and I spend many of my nights restin'' here under her pines when I can''t go home.

Our tribe warns folks to be watchin'' for her falling branches, but dey never hit me. Not one scar or bruise came from her.' WHERE `ID`=89513;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I am glad you made it back safe. I know if we keep looking we will find a key to ending the void''s corruption.' WHERE `ID`=89514;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very good results. Exceeds expectations.' WHERE `ID`=89516;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very good results. Exceeds expectations.' WHERE `ID`=89517;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very good results. Exceeds expectations.' WHERE `ID`=89518;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very good results. Exceeds expectations.' WHERE `ID`=89519;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very good results. Exceeds expectations.' WHERE `ID`=89520;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very good results. Exceeds expectations.' WHERE `ID`=89521;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very good results. Exceeds expectations.' WHERE `ID`=89522;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (89522,0,0,0,0,'Well, you aren''t dead. That''s a good sign.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very good results. Exceeds expectations.' WHERE `ID`=89523;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very good results. Exceeds expectations.' WHERE `ID`=89524;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very good results. Exceeds expectations.' WHERE `ID`=89525;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very good results. Exceeds expectations.' WHERE `ID`=89526;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very good results. Exceeds expectations.' WHERE `ID`=89527;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very good results. Exceeds expectations.' WHERE `ID`=89528;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (89528,0,0,0,0,'Well, you aren''t dead. That''s a good sign.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very good results. Exceeds expectations.' WHERE `ID`=89529;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (89529,0,0,0,0,'Well, you aren''t dead. That''s a good sign.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very good results. Exceeds expectations.' WHERE `ID`=89530;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (89530,0,0,0,0,'Well, you aren''t dead. That''s a good sign.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very good results. Exceeds expectations.' WHERE `ID`=89531;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very good results. Exceeds expectations.' WHERE `ID`=89532;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very good results. Exceeds expectations.' WHERE `ID`=89533;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very good results. Exceeds expectations.' WHERE `ID`=89534;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (89534,0,0,0,0,'Well, you aren''t dead. That''s a good sign.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very good results. Exceeds expectations.' WHERE `ID`=89535;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very good results. Exceeds expectations.' WHERE `ID`=89536;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very good results. Exceeds expectations.' WHERE `ID`=89537;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very good results. Exceeds expectations.' WHERE `ID`=89538;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very good results. Exceeds expectations.' WHERE `ID`=89539;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (89539,0,0,0,0,'Well, you aren''t dead. That''s a good sign.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='That was quite the experiment. I admit, I was not sure what to expect, but it was not that.' WHERE `ID`=89540;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very good results. Exceeds expectations.' WHERE `ID`=89541;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (89541,0,0,0,0,'Well, you aren''t dead. That''s a good sign.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very good results. Exceeds expectations.' WHERE `ID`=89542;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (89542,0,0,0,0,'Well, you aren''t dead. That''s a good sign.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very good results. Exceeds expectations.' WHERE `ID`=89543;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very good results. Exceeds expectations.' WHERE `ID`=89544;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very good results. Exceeds expectations.' WHERE `ID`=89545;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (89545,0,0,0,0,'Well, you aren''t dead. That''s a good sign.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very good results. Exceeds expectations.' WHERE `ID`=89546;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (89546,0,0,0,0,'Well, you aren''t dead. That''s a good sign.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very good results. Exceeds expectations.' WHERE `ID`=89547;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very good results. Exceeds expectations.' WHERE `ID`=89548;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (89548,0,0,0,0,'Well, you aren''t dead. That''s a good sign.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very good results. Exceeds expectations.' WHERE `ID`=89549;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very good results. Exceeds expectations.' WHERE `ID`=89550;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very good results. Exceeds expectations.' WHERE `ID`=89551;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very good results. Exceeds expectations.' WHERE `ID`=89552;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very good results. Exceeds expectations.' WHERE `ID`=89553;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (89553,0,0,0,0,'Well, you aren''t dead. That''s a good sign.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very good results. Exceeds expectations.' WHERE `ID`=89554;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very good results. Exceeds expectations.' WHERE `ID`=89555;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (89555,0,0,0,0,'Well, you aren''t dead. That''s a good sign.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very good results. Exceeds expectations.' WHERE `ID`=89556;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very good results. Exceeds expectations.' WHERE `ID`=89557;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (89557,0,0,0,0,'Well, you aren''t dead. That''s a good sign.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very good results. Exceeds expectations.' WHERE `ID`=89558;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Thank you, $n. Your adventures in Untethered Space will help clear the way for our Phase Divers to recover the energy that would have been lost to the Void.' WHERE `ID`=89561;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (89561,0,0,0,0,'Enhancing the Reshii Wraps is paramount to your survival.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='My younger brother left us when I was just comin'' of age.

He sent word he would come and help but... we did not part on good terms.

But here he is. After all dis time.' WHERE `ID`=89565;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The sum strength of a group of timerunners armed with potent artifacts is greater than that of the individuals. Much greater than anticipated. Intriguing.' WHERE `ID`=89590;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The sum strength of a group of timerunners armed with potent artifacts is greater than that of the individuals. Much greater than anticipated. Intriguing.' WHERE `ID`=89591;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Teamwork makes the dream work, or so they say. It would appear that the rhyme carries truth to it. Hmmm.

I wonder what other rhymes carry such power. That bears some future experimentation.' WHERE `ID`=89592;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The sum strength of a group of timerunners armed with potent artifacts is greater than that of the individuals. Much greater than anticipated. Intriguing.' WHERE `ID`=89593;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The sum strength of a group of timerunners armed with potent artifacts is greater than that of the individuals. Much greater than anticipated. Intriguing.' WHERE `ID`=89594;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Teamwork makes the dream work, or so they say. It would appear that the rhyme carries truth to it. Hmmm.

I wonder what other rhymes carry such power. That bears some future experimentation.' WHERE `ID`=89595;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Teamwork makes the dream work, or so they say. It would appear that the rhyme carries truth to it. Hmmm.

I wonder what other rhymes carry such power. That bears some future experimentation.' WHERE `ID`=89596;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Teamwork makes the dream work, or so they say. It would appear that the rhyme carries truth to it. Hmmm.

I wonder what other rhymes carry such power. That bears some future experimentation.' WHERE `ID`=89597;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Teamwork makes the dream work, or so they say. It would appear that the rhyme carries truth to it. Hmmm.

I wonder what other rhymes carry such power. That bears some future experimentation.' WHERE `ID`=89598;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Teamwork makes the dream work, or so they say. It would appear that the rhyme carries truth to it. Hmmm.

I wonder what other rhymes carry such power. That bears some future experimentation.' WHERE `ID`=89599;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Teamwork makes the dream work, or so they say. It would appear that the rhyme carries truth to it. Hmmm.

I wonder what other rhymes carry such power. That bears some future experimentation.' WHERE `ID`=89600;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Teamwork makes the dream work, or so they say. It would appear that the rhyme carries truth to it. Hmmm.

I wonder what other rhymes carry such power. That bears some future experimentation.' WHERE `ID`=89601;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Teamwork makes the dream work, or so they say. It would appear that the rhyme carries truth to it. Hmmm.

I wonder what other rhymes carry such power. That bears some future experimentation.' WHERE `ID`=89602;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Teamwork makes the dream work, or so they say. It would appear that the rhyme carries truth to it. Hmmm.

I wonder what other rhymes carry such power. That bears some future experimentation.' WHERE `ID`=89603;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The sum strength of a group of timerunners armed with potent artifacts is greater than that of the individuals. Much greater than anticipated. Intriguing.' WHERE `ID`=89604;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The sum strength of a group of timerunners armed with potent artifacts is greater than that of the individuals. Much greater than anticipated. Intriguing.' WHERE `ID`=89605;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The sum strength of a group of timerunners armed with potent artifacts is greater than that of the individuals. Much greater than anticipated. Intriguing.' WHERE `ID`=89606;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The sum strength of a group of timerunners armed with potent artifacts is greater than that of the individuals. Much greater than anticipated. Intriguing.' WHERE `ID`=89607;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Teamwork makes the dream work, or so they say. It would appear that the rhyme carries truth to it. Hmmm.

I wonder what other rhymes carry such power. That bears some future experimentation.' WHERE `ID`=89622;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The sum strength of a group of timerunners armed with potent artifacts is greater than that of the individuals. Much greater than anticipated. Intriguing.' WHERE `ID`=89644;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The sum strength of a group of timerunners armed with potent artifacts is greater than that of the individuals. Much greater than anticipated. Intriguing.' WHERE `ID`=89665;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The sum strength of a group of timerunners armed with potent artifacts is greater than that of the individuals. Much greater than anticipated. Intriguing.' WHERE `ID`=89676;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Teamwork makes the dream work, or so they say. It would appear that the rhyme carries truth to it. Hmmm.

I wonder what other rhymes carry such power. That bears some future experimentation.' WHERE `ID`=89677;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The sum strength of a group of timerunners armed with potent artifacts is greater than that of the individuals. Much greater than anticipated. Intriguing.' WHERE `ID`=89678;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Teamwork makes the dream work, or so they say. It would appear that the rhyme carries truth to it. Hmmm.

I wonder what other rhymes carry such power. That bears some future experimentation.' WHERE `ID`=89679;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Teamwork makes the dream work, or so they say. It would appear that the rhyme carries truth to it. Hmmm.

I wonder what other rhymes carry such power. That bears some future experimentation.' WHERE `ID`=89680;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The sum strength of a group of timerunners armed with potent artifacts is greater than that of the individuals. Much greater than anticipated. Intriguing.' WHERE `ID`=89681;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Teamwork makes the dream work, or so they say. It would appear that the rhyme carries truth to it. Hmmm.

I wonder what other rhymes carry such power. That bears some future experimentation.' WHERE `ID`=89682;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The sum strength of a group of timerunners armed with potent artifacts is greater than that of the individuals. Much greater than anticipated. Intriguing.' WHERE `ID`=89683;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You know... I thought I would be sad if this didn''t work, but I actually feel okay!

I still believe. There''s so much magic in the world. And even if Aln''sharan isn''t exactly what I think he is... his story still exists for a reason. And that''s important to me, I think.' WHERE `ID`=90474;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Intriguing. This artifact''s potential has been deepened, perhaps by the fraying of this timeline. It can harness more power than any incarnation of it that I have yet encountered.

Let me record that data point for Moratari.

Oh, important reminder--don''t forget to recover the bronze simulacrum later or things might get... funky.

And lastly, maybe don''t mention to people how you got that. It could ruin the experiment.' WHERE `ID`=90659;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='We persevere for now, $n. The quicker we face Xal''atath at the Voidspire, the quicker this can all be behind us.' WHERE `ID`=90777;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (90777,0,0,0,0,'It''s heartening to see our commanders so eager to bring the fight to the enemy.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Thank you, $n.

I hope the water is as powerful as my mentor says it is. The strong poison of these creatures suggests I''m going to need it to survive the ritual.' WHERE `ID`=90826;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Here, yes... With that information I can make some final tweaks. And adding this directive...

Ah! That should do it. If you insert this into yer durable information storage container, it should update the effectiveness of the device''s, um... effects.' WHERE `ID`=91026;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Hope you like getting your hands dirty.' WHERE `ID`=91345;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Fidoficus will be renowned for his ferocity.

I can see the violence growing in him.

One day, he will be a worthy pet for a domanaar such as myself.' WHERE `ID`=91363;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='A single heroic act can turn the tide. A single whisper of hope can turn back despair. This is what gives legends their power.' WHERE `ID`=91438;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Well done, $n. Moratari will be overjoyed to see these new data points.' WHERE `ID`=91444;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91444,0,0,0,0,'We need more fight data to complete our study, and time is running short.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Well done, $n. Moratari will be overjoyed to see these new data points.' WHERE `ID`=91445;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Well done, $n. Moratari will be overjoyed to see these new data points.' WHERE `ID`=91446;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='There are consoles inside the Manaforge that keep the flow of energy running smoothly within the facility. We''ve cracked security on the first set of them, allowing you to turn the tables on enemies near Loom''ithar and Soulbinder Naazindrhi. You''ll only be able to use one, but sabotaging them should allow you an edge in battle. Good luck in there.' WHERE `ID`=91483;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='We found a weakness in Forgeweaver Araz''s engineering bay that should allow you access to another console nearby. Keep up the pressure, and we''ll let you know once the whole facility is ours. Happy hunting.' WHERE `ID`=91484;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Manaforge Omega''s security systems are under our direct control. Thanks to the damage you''ve done in there, we can get you access to consoles extending all the way to Salhadaar, and whatever lies beyond. We''ve also ensured you can use every console you come across. That''s all I can do for you. Get in there and finish the fight.' WHERE `ID`=91485;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Its quality is unlike anything I''ve ever seen! I''ll get to work right away. Now, let''s discuss your payment.' WHERE `ID`=91525;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91525,0,0,0,0,'Have you procured a sample?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='<Name>... I should have seen that coming. His devotion to Dimensius knew no bounds, and he certainly had contingencies in place to make sure the ritual would be completed. We''ll have to attack from another angle. We found some debris from his inner sanctum that made its way here - if you have the skill, we can teach you how to use it for your own ends.' WHERE `ID`=91526;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91526,0,0,0,0,'Does the Forgeweaver yet live?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Soul energy like I''ve never seen it. While we cannot return them to the way they were, I believe you can use these runes to empower yourself even *through* death. Take them with you, and use them wisely.' WHERE `ID`=91527;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91527,0,0,0,0,'How fares your battle with the interlopers?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Nicely done, champion. The resources they were hoarding will find a much better home with your companions.' WHERE `ID`=91528;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91528,0,0,0,0,'Have you eliminated your targets?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Though not the end he deserved, we will celebrate his defeat nonetheless. See Zo''ropo to trade for a well-deserved reward. You have my eternal gratitude for deposing him.' WHERE `ID`=91529;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91529,0,0,0,0,'Strike swiftly, champion. Do not let Salhadaar escape justice.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I''m glad I went through with this. Thanks for coming with me.

Let''s get back to the others in the Voidstorm, $n.' WHERE `ID`=91546;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Thank you so much for rescuing me... not that I needed it of course. Anyway, you seem to be pretty good yourself. So after talking with everyone, we all agreed to make you a part of our group!

Be proud. This is an honor only few have received, but you''ve earned every bit. You are officially one of us! Be proud, stand tall, and never give up!' WHERE `ID`=91553;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Riftwalker Lorn is dead? This is troubling news. 

You have my gratitude for saving as many of the ren''dorei as you did.' WHERE `ID`=91560;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Excellent. Even an old cook can work wonders with good hands beside him.' WHERE `ID`=91585;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Good. The rutaani will accept this without complaint. Peace rests on gestures such as these.' WHERE `ID`=91586;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I don''t know what this fake bear is planning.

But it''s better that his lodestones are destroyed.' WHERE `ID`=91748;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The bag feels... tempting. I don''t like it!

Good he kept this away from others, but also very bad for him.' WHERE `ID`=91749;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='<Name>, you have been an excellent assistant with our research. I think you deserve a promotion.

From now on, you will be able to take on more research assignments simultaneously.

It''s ironic, isn''t it, that we never seem to have enough time. Make good use of your time here. Don''t make me regret granting you this power.' WHERE `ID`=91844;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='<Name>, you have been an excellent assistant with our research. I think you deserve a promotion.

From now on, you will be able to take on more research assignments simultaneously.

It''s ironic, isn''t it, that we never seem to have enough time. Make good use of your time here. Don''t make me regret granting you this power.' WHERE `ID`=91845;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Did you find any good pieces for your house? We hope to have more vendors visit in the future, so be sure to check back often!' WHERE `ID`=94210;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (94210,0,0,0,0,'Have you met all the local vendors? They have some great furnishings available.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Did the renovation go well? I hope it gives you a little more room for all the treasures you find in your adventures.

Be sure to visit the general contractor again when you''re next ready for an upgrade.

Oh, and a letter arrived for you while you were away.' WHERE `ID`=94379;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (94379,0,0,0,0,'Did you get your house upgraded?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Make yourself at home!' WHERE `ID`=94455;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Thank you. I think I''ve got a hold over my senses now.

It''s so strange. Antenorian called me a child of the Light and yet...' WHERE `ID`=94528;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (94528,0,0,0,0,'It''s like one half of me is at war with the other half.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='It''s all a trap. Ula''tek''s death will only unleash something worse.

The Twilight''s Blade knew this. And we were blind.

I was blind.' WHERE `ID`=94530;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='That''s everything we need. I''ll craft the lure. Next, we take down that monster!' WHERE `ID`=94803;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (94803,0,0,0,0,'Do you have the last piece of Ssak''mozek''s lure? We need feathers--the brighter, the better.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I could hear the angry hissing from here, $n! Hopefully the Children of Ula''tek will stay away from our fishing spot for a while.' WHERE `ID`=94805;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (94805,0,0,0,0,'I can still see the poachers roaming about. Can you get rid of a few more? I don''t like how close they are to our camp here!',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='These will do excellent! Ssak''mozek lurks beneath the water. The smell from these leech legs will help draw it to you.' WHERE `ID`=94806;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (94806,0,0,0,0,'Don''t break the leech legs, if you can. We need to break them right before we make the lure so the smell is fresh.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The hard work is paying off I see - great job! Return back to me next week.' WHERE `ID`=94836;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (94836,0,0,0,0,'You have yet to finish your training for the week.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Well done completing the training program. For your hard work, take this! As you continue your journeys in battle, you can return back to me to become better equipped.' WHERE `ID`=94838;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (94838,0,0,0,0,'You have yet to finish your training for the week.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Ah ha! De feathers!

Dey will protect ya during de hatchin'' ritual, but we must work a little magic on ya first. I taught Shaja the protection blessin'' while you were runnin'' about.

Do not worry! She is a natural.' WHERE `ID`=94870;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (94870,0,0,0,0,'Ya got de feathers? Or are ya gonna melt?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I''m glad you''ve chosen to join me here, $n.' WHERE `ID`=94933;
UPDATE `world`.`quest_template` SET `QuestDescription`=';Founder''s Point
Welcome, neighbor! I''ve got just the thing for you here. These dyes I have here will let you give the decor you buy from our local decor vendors an extra pop of color. Take these and try them out, no charge. Be careful, though. Each only works once.

And if you want more, alchemists and scribes can grind up herbs to create pigments, when use those pigments at this dye station to create more dyes. You can also probably find them on the Auction House, if you''re not interested in making your own.

;Razorwind Shores
I have something for you, neighbor. Just between you and me, these decor vendors don''t always have the greatest palette sensibilities. I hope yours are better. If you''re going to put those... things in your house? Try recoloring them with these dyes. Each dye can be used just once, so make sure you like what you''re doing before you apply them.

But if you want more, any scribe or alchemist can grind up herbs to create pigments, then use those pigments at this station to make more dyes.' WHERE `ID`=94995;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Ah, well done. Another successful Oblivium catalyzation. The Nilhammer grows stronger!' WHERE `ID`=95269;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The Ascendant Netherhammer! A tool truly worthy of an artisan of my skill. The things I will be able to create... Of course, you will be rewarded for your efforts. Take this Ascendant Voidshard. You will need several more before you can coalesce them into an :Ascendant Voidcore. I will help you transfer its energies into your most powerful equipment at the Voidforge.' WHERE `ID`=95271;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The haranir seek to join the fight against the Void?

Far be it from me to look a gift hawkstrider in the mouth. Halduron has vouched for both their strength and their tenacity. We shall need a great deal of both, in the battles to come.' WHERE `ID`=95324;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Oh yah, I can use these--I mean Shajanji will be happy with these in her collection.

Ya did good.' WHERE `ID`=95336;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (95336,0,0,0,0,'Did ya help out Shajanji?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You''re a lifesaver! And we''re certain none of those letters or packages ended up in a ditch somewhere, right?' WHERE `ID`=95416;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (95416,0,0,0,0,'Neither scourge nor fel nor void nor dragon''s flame shall stay we couriers from the swift delivery of our entrusted missives!',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='"Time spent with good company is time spent optimally" - Conjurer Margoss' WHERE `ID`=95440;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Well done, $n!' WHERE `ID`=95468;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (95468,0,0,0,0,'You must fight, $n.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I have not seen de likes of dis since I walked de land of de livin''.

I believe ye found one of de honored Med''jai medallions, possessed by heroic warriors believed to guard dis temple wit'' their very souls.' WHERE `ID`=95521;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I see much has changed, gokinye.

As a warrior, I fought for de Amani on de field of battle. My blade was feared amongst our enemies.

When my people asked for me to watch over dis temple, I was de first to step forward. There is no greater honor than to give your life for your people. And I am proud to do it.

But looking around, I wonder. Was our sacrifice in vain?' WHERE `ID`=95522;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Dis is good. Their cursed souls will only know oblivion.' WHERE `ID`=95523;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (95523,0,0,0,0,'Defeat is not enough, $n. Annihilate their very souls.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Thank you, $n. I had wished for better, but it helps to know their fates in dis world.' WHERE `ID`=95524;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (95524,0,0,0,0,'Have you found dem, $n? My brothers and sisters.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Good.

For far too long we have been beset by threats. Striking back will send a message.' WHERE `ID`=95550;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (95550,0,0,0,0,'Is the job done?',0);
UPDATE `world`.`quest_template` SET `QuestDescription`=':Aid the ongoing battle against the Children of Ula''tek.' WHERE `ID`=95580;
UPDATE `world`.`quest_template` SET `QuestDescription`=':Aid the ongoing battle against the Children of Ula''tek.' WHERE `ID`=95598;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Zul''jan...

Why would you do dis, brother?' WHERE `ID`=95804;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (95804,0,0,0,0,'We need to find out more about dis island if we gonna find our people.',0);
