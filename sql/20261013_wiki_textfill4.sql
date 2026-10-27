-- Fill empty quest texts from Wiki batch P4.
-- Undo: 20261013_wiki_textfill4_undo.sql
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Welcome, $c. Try not to give our position away.

We wouldn''t last long if Kael''s cronies sniff us out.' WHERE `ID`=10652;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You found the Idol of Ohn''ahra! I suppose I shouldn''t be surprised.

We need to get artifacts like this back to their rightful places. But if my superiors are right, we can''t risk letting them fall into the wrong hands. 

Let me examine the idol.' WHERE `ID`=77304;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (77304,0,0,0,0,'What have you found?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Nice! This''ll get ''em patched up and good to go!' WHERE `ID`=86274;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86274,0,0,0,0,'Time is... you know what it is.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Bleh. Disgusting, but effective. Now I can get back to work!' WHERE `ID`=86275;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86275,0,0,0,0,'Ahh!

Oh, I thought you were another bloodfeaster.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Whoa, I see you took my words to heart!

Remember to hit the shower after you''re done here, okay?' WHERE `ID`=86277;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86277,0,0,0,0,'You flattened that thing yet?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I appreciate ye making such a big sacrifice, $n. Your work here will never be forgotten.' WHERE `ID`=86358;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86358,0,0,0,0,'What do you think of the wee li''l pups?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Excellent--play can be as useful as training, on some occasions.' WHERE `ID`=86361;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86361,0,0,0,0,'Has a kit been sufficiently trained?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Excellent! Combine the two fractured sparks of fortunes to create a powerful spark of fortunes. You can always combine more using your own crafting efforts.' WHERE `ID`=86369;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86369,0,0,0,0,'Were you able to find a fractured spark of fortunes? Is that a yes? No?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Where did you find this crystal? I can hear it. in my head, singing to me.' WHERE `ID`=86456;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86456,0,0,0,0,'I am dealing with another crisis in my eco-domes, $n. Make it quick or move aside.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I can''t believe it! I...

<Name>, what you have found is going to change the future of K''aresh.

The future of my people.' WHERE `ID`=86457;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86457,0,0,0,0,'If this crystal is what I think it is, we have found a new hope of saving K''aresh.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='What transpired here will echo for years to come. The change will not happen within a day, a week, or even months. But with hope rekindled, we will get there, and we will be united once again.

You have saved us all, champion.' WHERE `ID`=86458;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86458,0,0,0,0,'We must make Soul-Scribe see reason. We must prevent her oath to Salhadaar from dooming K''aresh.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I will begin research on this new material immediately! You have my gratitude, $n.

You are welcome to help yourself to the newest sets of armaments I have recently forged.

They were slated for delivery to the Awakening Machine, but since they seem like the perfect size for you, you are welcome to sample my work.' WHERE `ID`=86496;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86496,0,0,0,0,'Have you found more splinters of the Siren Crystal? I think I may be able to create something useful with them.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Ah, $n, you have returned. An otherworldly air hangs heavy about you.' WHERE `ID`=86556;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Ah, $n, you have returned. An misty air hangs heavy about you.' WHERE `ID`=86560;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86560,0,0,0,0,'I foresee that you will follow the shrouded star, and walk the paths it reveals.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Ah, $n, you have returned. An otherworldly air hangs heavy about you.' WHERE `ID`=86563;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86563,0,0,0,0,'I foresee that you will follow the brutal star and walk the paths it reveals.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Ah, $n, you have returned. An fel air hangs heavy about you.' WHERE `ID`=86564;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86564,0,0,0,0,'I foresee that you will follow the corrupting red star and walk the paths it reveals.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Bah! There is no mastery in this. I''ve seen oozes spew out better plagues than this! Of course, I made those oozes.' WHERE `ID`=86589;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86589,0,0,0,0,'Do you have those samples for me?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Oh bother. I should have asked you to get his remains. I could have used them.' WHERE `ID`=86591;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86591,0,0,0,0,'Is the deed done?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Seems like they''ll eat just about anything. Omnivores--that''s a handy thing to have.' WHERE `ID`=86594;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86594,0,0,0,0,'Feeding time. Get to it!',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Excellent work! We will administer the concoction and monitor for issues.' WHERE `ID`=86605;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86605,0,0,0,0,'Have you gathered the necrorays?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You did right by my little princess.' WHERE `ID`=87008;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (87008,0,0,0,0,'Ain''t it great to see those two crazy kids hitched?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='With dis many, we can work our magic to heal de whole war party too!' WHERE `ID`=87256;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='These are excellent. Your photography skills are to be commended. I particularly enjoy this one with Sir Cuteington. 

Thank you.' WHERE `ID`=87294;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (87294,0,0,0,0,'Have you gotten those photos? Do make sure your charming face is in them as well.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Since Xal''atath''s sudden yet inevitable betrayals aren''t a problem for you, I''ll make sure to only give you really Resilient keystones from now on.
 
It''s OK to ask me for an easier one, though. Everyone needs a break sometimes.' WHERE `ID`=87327;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (87327,0,0,0,0,'You have achieved much. Your deeds are Legendary.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Hello there, $c. So you''re our latest test subject--I mean, the one to revisit the visions of the past?

I hear you have some displaced corrupted mementos from your last trip.

Perfect! I''ll show you what they can do.' WHERE `ID`=87332;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Fine work, be sure to check the warrant board for additional threats as they arise.' WHERE `ID`=87344;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (87344,0,0,0,0,'Have you completed a warrant.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='There may be a time and place for caution, but now is not that time.

I hunger for results!' WHERE `ID`=87388;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You did what was required. If the cargo is gone, that is a victory--but our work is far from over.

The Tideborne must still answer for their actions.' WHERE `ID`=87397;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='If this works, it will be the greatest thing I have ever achieved--retrieving a species from extinction.' WHERE `ID`=87408;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (87408,0,0,0,0,'Have you gathered the essences I needed?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Ah, I can already smell the change on the wind. Thanks so much!' WHERE `ID`=87413;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (87413,0,0,0,0,'Have you cleaned up those dirty birdies?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='They got some pretty nice selections, don''t they?

If you ever need help findin'' them again, lemme know.' WHERE `ID`=87496;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (87496,0,0,0,0,'You can find the sellers at each cartel''s headquarters.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='We were able to save so few, $n.

I''m pleased at the work we did, but I wish we could have done more.' WHERE `ID`=88702;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I knew I could trust in you to complete such a feat.' WHERE `ID`=88808;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (88808,0,0,0,0,'The fires of war burn once more.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Well done, <Name>. The forest marches to war.' WHERE `ID`=88925;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (88925,0,0,0,0,'Have you any luck uprooting those old ones?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Good. An ancient protector is capable of striking foes from afar with their boulders. be they on the ground or flying in the air.' WHERE `ID`=88927;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (88927,0,0,0,0,'Have you gathered the ancients, $n?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='There were far more cultists than I would have expected. How long have they been infiltrating our society?' WHERE `ID`=88929;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (88929,0,0,0,0,'How many of my people have been taken by this evil?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='With the ancients by our side, we will be unstoppable.' WHERE `ID`=88937;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (88937,0,0,0,0,'What stories does the ancient of lore have to tell, I wonder?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='De boy looks confused.

Good. Maybe he''s thinkin''.' WHERE `ID`=88986;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You saved de boy''s life. And maybe now he will think before he rushes off and makes a life-endin'' decision.

And eliminatin'' de head of de sabotage ring will allow us de time to make all de weapons we need.

Things tend to work out for de best, eh? Even for you.

Here''s a little somethin'' de crew and I want you to have.' WHERE `ID`=88989;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Your ability to throw me the correct items is very valuable. You would not believe how frequently people lack that skill.' WHERE `ID`=89192;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (89192,0,0,0,0,'Come now. Let us begin.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Making yourself useful is a prized quality in Silvermoon. You are well on your way.' WHERE `ID`=89199;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You''ve finished? Then buzz off!

A pun! Merely a pun!' WHERE `ID`=89209;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (89209,0,0,0,0,'Goodness! They''re terribly busy, aren''t they?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='My goodness! I have never seen Skibbles this excited! It sounds like she made quite the impression with the Lamplighters. 

Speaking of children, I was watching the other Arathi children play and noticed that Destien seems more interested in his book than joining in. 

Perhaps you could talk to him? Surely there is something he would rather do than stay here.' WHERE `ID`=89318;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (89318,0,0,0,0,'Oh, hello $n. I''ve had a wonderful time chatting with the orphanage patron here. After watching the children play, I am starting to see why my previous activities weren''t as exciting for the younglings I am watching. 

They do not seem as interested in city tours but instead have an incredible capacity to pretend! Fascinating. 

Oh, I almost forgot--did you get a chance to take Skibbles to see the Lamplighters?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='<Name>, I can''t thank you enough. All of these children look like they have bright futures ahead of them, and you played no small part in that. 

Thanks to you, I also feel as if I understand children a bit better. They are truly wonderful, even if they are a handful at times. 

 

I know you are very busy, but I do hope we will see you next year!' WHERE `ID`=89322;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (89322,0,0,0,0,'Have you had a chance to speak with the benefactors?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Retain the fragment for now.

I will need it soon.' WHERE `ID`=89324;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Thank the Sacred Flame for your assistance. The war continues but at least the battle is won.' WHERE `ID`=89332;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Thank you for accepting our offer, $n. This is dangerous work that will push you beyond the limits of our reality. But with risk we find profit, and with profit we can change the world.' WHERE `ID`=89380;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I''ve been told frog legs taste like a curious blend of fish and poultry. I... think I will leave that fine dining experience to the hawkstriders, however. Thank you for your help!' WHERE `ID`=89384;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Oh, they''ll have many a happy night''s sleep on this! You have my thanks.' WHERE `ID`=89386;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='And here we are, back where it all started.

In a moment a messenger will come looking for you and your legend will begin to unfold.

Aren''t you excited? I know I am.

Oh, and if you need anything, just come by the Infinite Bazaar. We''re always waiting.

Good luck!' WHERE `ID`=89418;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='<Name>! Glad you could make it. I wanted to formally congratulate you on your new position within our ranks.

You''ve more than earned this, demonstrating courage and traits that show great promise as you continue serving Flame''s Radiance.

On that note, please accept and don this tabard in your future endeavors. We look forward to seeing you on the battlefield.' WHERE `ID`=89494;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Thank you for helpin'' us on dis journey, $n.

I didn''t think Iz''ken would come, and he didn''t think he''d be welcome.

I think Iz''ken and I realize now... de worst trick our mother pulled was pittin'' us against each other.' WHERE `ID`=89560;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Another task completed. The Trust thanks you for your efforts. The founder has set aside a fund to encourage such initiative.' WHERE `ID`=90637;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Another task completed. The Trust thanks you for your efforts. The founder has set aside a fund to encourage such initiative.' WHERE `ID`=90638;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Excellent work, $n! You have procured a perfectly, pleasingly, plumply proportioned pescatarian prize!

Joyous day!' WHERE `ID`=91271;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='This is what happens when there''s no one around to sweep up!

Everyone wants to adventure, but no one wants to sweep.' WHERE `ID`=91350;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Is the beast''s savagery growing?

I''m sure I will begin to hear of his violence from those around the Howling Ridge.' WHERE `ID`=91380;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91380,0,0,0,0,'He is still small, but one day, he will grow to be a terrible foe.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Excellent timing, $n. Now the research can begin.' WHERE `ID`=91437;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='My friend! We''ve secured new technology to help you bring down the Shadowguard - put it to good use!' WHERE `ID`=91477;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='My friend! We''ve secured new technology to help you bring down the Shadowguard - put it to good use!' WHERE `ID`=91478;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='My friend! We''ve secured new technology to help you bring down the Shadowguard - put it to good use!' WHERE `ID`=91479;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='With this, you are as powerful as our humble band of soundrels can make you. May it serve you well against Dimensius!' WHERE `ID`=91480;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='My research shows that due to the Reshii Wraps'' influence on your physical form, the powerful manasurges and reactors inside Omega can be used to your benefit! While this is only a fraction of your power, it seems that arcane enhancements made to your armaments are made ever more powerful while in their vicinity. This warrants further testing...' WHERE `ID`=91486;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='With the mutated pathogen dealt with and the antidote in hand, we should be safe from further outbreaks. Thank you for your assistance, $n.' WHERE `ID`=91561;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='This carcass breathes new sustenance into the fungarians and the peace we uphold.' WHERE `ID`=91587;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Gral''s power, my soul... it''s all here again. Thank you for returnin'' my bones, $n.' WHERE `ID`=94031;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (94031,0,0,0,0,'This ritual was an odd one my teacher taught me a long, long time ago.

I never thought I''d need to perform rituals as a ghost, but I couldn''t imagine how angry de captain would become.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='It was good of you to check on me, but I''m committed to the Farstriders!' WHERE `ID`=94371;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='This piece of equipment will be perfect!

I can help you make this more powerful, but we''ll need some reagents.' WHERE `ID`=94430;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (94430,0,0,0,0,'If you''re having trouble finding a piece of Adventurer equipment, try talking to some people throughout Eversong, Zul''Aman, Harandar, and Voidstorm who look like they need some help with a task. They might be willing to reward you with equipment for your aid.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You reek of anguish.

Exquisite.' WHERE `ID`=94446;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (94446,0,0,0,0,'Can you still discern reality from nightmare? If so, you should be pushing yourself harder. That way lies true power.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='So Xal''atath opened a gateway through the Darkwell, and the Twilight''s Blade are awaiting the arrival of some Dark General.

How do they know it is coming? And where will it appear?

This is growing more complicated by the moment, and more alarming.' WHERE `ID`=94529;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (94529,0,0,0,0,'Have you found any more of the Twilight Blade''s plans?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Ah, the nascent Voidforge is ready! Oh the things I... I mean we, will be able to do with this...' WHERE `ID`=94623;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (94623,0,0,0,0,'Back already, $n? Pick up any fresh scars?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Excellent. One more Elemental Voidcore for the Voidforge!' WHERE `ID`=94625;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (94625,0,0,0,0,'You certainly weren''t in any rush with this one, $n. I suppose the gates of time can''t be rushed, can they?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You''ve slain the Hoarder! We have a window to fish our fill, thanks to you. You should get back out there!' WHERE `ID`=94804;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (94804,0,0,0,0,'The Hoarder isn''t careful about his fishing. He kills anything that swims, curse or no curse/',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Ah, looks like you found something shiny after all! The Voidforge will provide me with additional reagents to weave more Nebulous Voidcores over time, so be sure to check back later.' WHERE `ID`=95373;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (95373,0,0,0,0,'Back already, $n? Were you able to transmute the Nebulous Voidcore?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Ah, I can hear Thaze''ala now. You have awoken her heroic spirit in dis gem, $n.

Perhaps with her wisdom we will learn much about how our great shame was only held back by de heroic sacrifice of our people.' WHERE `ID`=95525;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I go through axes quick as anyting.

I''ll happily take it off yer hands.' WHERE `ID`=95589;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (95589,0,0,0,0,'Need some choppin'' done?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The High Priest''s presence has dissipated, at least for now. It remains to be seen if he''s capable of taking form again.

But if so, we will be ready.' WHERE `ID`=95954;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (95954,0,0,0,0,'I may not be flesh and blood, $n, but perhaps there is still work left for me to do.',0);
