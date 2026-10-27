-- Fill empty quest texts from Wiki batches F/G (verbatim, markup resolved).
-- Undo: 20261013_wiki_textfill2_undo.sql
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='A single heroic act can turn the tide. A single whisper of hope can turn back despair. This is what gives legends their power.' WHERE `ID`=90096;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The power you and your artifact possess were able to halt a Legion invasion. But was it you, or the artifact you wield, that is responsible? On that I will require more information.' WHERE `ID`=90097;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Just as I predicted. You were able to stop a massive Legion invasion. It was not you, or your artifact that did this. Rather it was the combination of both that won the day.' WHERE `ID`=90098;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Well done, $n. Moratari will be overjoyed to see these new data points.' WHERE `ID`=90099;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Well done, $n. Moratari will be overjoyed to see these new data points.' WHERE `ID`=90100;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='A fascinating outcome, $n. This will shed some much needed light on our research.' WHERE `ID`=90101;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Your legend has grown, $n. The timeline reverberates with not just the substance of your deeds, but it compounds as it impacts those around you. This has been a most fruitful addition to our research.' WHERE `ID`=90102;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You have gained the respect due to a true $c. You are a leader. All that remains to be answered is where you are going.' WHERE `ID`=90103;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (90103,0,0,0,0,'The respect of your peers must be earned, it cannot be given.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You have quite the collection now, $n. All that remains to be seen is whether you prefer one artifact over the other.' WHERE `ID`=90108;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Good. Nothing dramatic occured when you gathered the residual time motes. If you start to feel anything strange, do let us know though.' WHERE `ID`=90109;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Moratari will be elated to see so many test samples. Thank you for your diligence.' WHERE `ID`=90110;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Well done, $n. Moratari will be overjoyed to see these new data points.' WHERE `ID`=90111;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (90111,0,0,0,0,'We need more fight data to complete our study, and time is running short.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Well done, $n. Moratari will be overjoyed to see these new data points.' WHERE `ID`=90112;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Impressive. I can sense your power. This is a most critical addition to our research.' WHERE `ID`=90113;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Impressive. I can sense your power. This is a most critical addition to our research.' WHERE `ID`=90114;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Impressive. I can sense your power. This is a most critical addition to our research.' WHERE `ID`=90115;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='He confirmed what he''d sent was a letter of approval? Good! I''m glad that''s cleared up.
Maybe now we can get a more pleasant introduction to Zul''Aman.' WHERE `ID`=90481;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Excellent. Now to prepare it.' WHERE `ID`=90482;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I see. They keep clear records of all these battles at least. Their storytelling is quite strenuous!' WHERE `ID`=90483;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Steggy is back! You really are response-able.' WHERE `ID`=90484;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='My my, what an interesting find!
There''s a lot to be learned from an old pot: how the ancient Amani might have prepared food, the kinds of food they ate, and what they valued most in a meal.
I''ll work on analyzing this. You can place those other items to the side. They''re far younger than this beauty.' WHERE `ID`=90485;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You have my ribbon. Go--track down the rest. Have Locus-Walker contact the other members of the Ravel. Ask the Harbinger if she knows any ancient horrors that have acquired one. Remember rule twelve--it''s who you know.' WHERE `ID`=90517;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='There. Now you are part of Harandar.' WHERE `ID`=90535;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='<Luma nudges a small reward into your hand, as if in appreciation for your help.
Perhaps there is no reason to be concerned over the amount of stolen items in the treasure pile after all.>' WHERE `ID`=90544;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Fine work. I am most pleased to not have to handle those nasty fish myself.' WHERE `ID`=90545;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (90545,0,0,0,0,'Did you catch those fish?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Well, the cultists don''t seem to be hiding now. But I don''t see any of our missing paladins.' WHERE `ID`=90546;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Well, the cultists don''t seem to be hiding now. But I don''t see any of our missing paladins.' WHERE `ID`=90547;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Good job out there. We''ll need to find more if we''re going to find our missing friends.' WHERE `ID`=90548;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Well, we know more. They were here at one point but they''ve been taken, unarmed. Now we need to find out where to.' WHERE `ID`=90549;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Those bastards... They''ll pay for Sombersun''s death!' WHERE `ID`=90550;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The Ruins of Deatholme. They better be alive when we get there!' WHERE `ID`=90552;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='We have wiped Eversong clean of their filth.' WHERE `ID`=90553;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Good work. Even if they come crawling back, they won''t find much.' WHERE `ID`=90554;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='All things considered, this was a good result. I wish... well. We couldn''t save everyone, but we did save most of them. I guess that''s as much as anyone can ask for in a situation like this.' WHERE `ID`=90555;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Hey pal, we found a weird key lying around. No idea who it belongs to, it ain''t for the Incontinental. You want it?' WHERE `ID`=90557;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Good--you made it. Now let''s save those paladins.' WHERE `ID`=90570;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Your strength is matched only by your acuity, my dear. I will ensure everyone knows how marvelously you have performed today.' WHERE `ID`=90573;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Your deeds honor us, $n. You have fought well this day.' WHERE `ID`=90574;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Nice work. You know how to see a mission through smoothly. I have a few ranger recruits who could learn a thing or two from you.' WHERE `ID`=90575;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (90575,0,0,0,0,'We need to keep those runestones safe.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Ha! I shouldn''t be surprised you pulled that off so well, but here we are. We''ve already got people looking at us like we''re miracle workers.
All thanks to you, $n.' WHERE `ID`=90576;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (90576,0,0,0,0,'Those runestones aren''t going to charge themselves.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='What is this? Ru''gar''s notes on his cultivation efforts!
This is fantastic. I can try to reproduce his work now.
Good work taking out Gomphusta, also. May this throw the fungarians into disarray and keep travelers on the roads safer.' WHERE `ID`=90602;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You look like could put up strong fight before start decay.
Would be very interesting!' WHERE `ID`=90615;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='We, uh... you are so strong.
How, er...? You very different.
Teach fungarians, to be different like you?' WHERE `ID`=90616;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You found ones to teach?
First step is to fight, see what can do!' WHERE `ID`=90617;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Another task completed. The Trust thanks you for your efforts. The founder has set aside a fund to encourage such initiative.' WHERE `ID`=90630;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Another task completed. The Trust thanks you for your efforts. The founder has set aside a fund to encourage such initiative.' WHERE `ID`=90667;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Tales of your own accomplishments mingle into the chorus of echoes emanating from the now repaired stone.' WHERE `ID`=90670;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Good, $n! You have made it for our charge.' WHERE `ID`=90690;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Way to go, $n. You have to show those bombs who''s boss, you know?' WHERE `ID`=90701;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Hmm. Let''s see here.
Warpstalker eyes, an astral sieve-
Jormungar bile?! How does he plan to use that? And I am down to my last few vials.
Well, it can''t be helped. I will send these on to Oculeth as soon as they are gathered. In the meantime, enjoy yourself around the tavern, Champion.' WHERE `ID`=90718;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (90718,0,0,0,0,'Champion? Do you have something for me?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Yes, by combining this residue with the displaced corrupted mementos I can... yeah just like so... and then with a bit of my bronze magic... there. Done.
Now that I have a working knowledge I can also make more if you bring me additional displaced corrupted mementos. I will see if I can refine the process anymore. Check back with me later.' WHERE `ID`=90719;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='This is a dark day.
I am deploying my scouts to learn more of what is transpiring in the world while we use our remaining forces to defend Silvermoon City.
Be ready, champion. We will have need of you soon.' WHERE `ID`=90724;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You did so well! I may have to employ you more often!' WHERE `ID`=90729;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (90729,0,0,0,0,'Did you sell the items?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Ok, this is promising... the coagulate catalyzes slower so the increased corruption is more contained... yes, this allows a higher yield of corrupted material without any negative side effects.
Alas, I cannot keep it stable for long. These effects will not last. I am sorry adventurer but we should take advantage of the effects while we can.
Again, if you bring me additional displaced corrupted mementos I can make you more of these greater corruptions.' WHERE `ID`=90731;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Good. This will be a profitable venture... for me.' WHERE `ID`=90747;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (90747,0,0,0,0,'Are you ready to help?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='There are Twilight''s Blade in the city. If they are here, they are certainly recruiting elsewhere.
We have more work to do.' WHERE `ID`=90760;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='There are Twilight''s Blade in the city. If they are here, they are certainly recruiting elsewhere.
We have more work to do.' WHERE `ID`=90761;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='May the spirits protect you mon, and your new blue friend!' WHERE `ID`=90769;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Good work, mon. Griftah be smiling today.' WHERE `ID`=90770;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (90770,0,0,0,0,'Did you find da treasures?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='This should be more than enough.
I''ll be careful with them. I wouldn''t want to poison myself prematurely.' WHERE `ID`=90827;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='It is done. There is but one thing left to do once En''liahn has recovered.
But first, we should leave the rift immediately. This is no place to linger.' WHERE `ID`=90832;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Keep yourself out of sight. I would rather not risk a bleak fate.' WHERE `ID`=90838;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Excellent choice! I''m looking forward to what you do next.
Take this riding mount. It''ll help you get around here faster.' WHERE `ID`=90840;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (90840,0,0,0,0,'Having trouble? You can find your combat specialization beside your spellbook.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='If you ever find yourself lost, use your Hearthstone to get yourself back to where you should be.' WHERE `ID`=90842;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (90842,0,0,0,0,'Happy Hal nearby can get you set up with a Hearthstone.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='How are ya? We could use more hands to help us explore the Dragon Isles!' WHERE `ID`=90843;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Something has sparked a rebellious fire in some of the Shadowguard.
Let us see what more we can find.' WHERE `ID`=90844;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I do recognize some of these items! They belonged to close friends and family.
If my sister''s necklace is to be found, it will be here.' WHERE `ID`=90845;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='<Name>! This necklace belongs to Veraan! Veraan IS Sombersong!' WHERE `ID`=90847;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Violence is rarely an occasion for celebration, but I am glad we have at least slowed the deeds occurring here.' WHERE `ID`=90851;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Thank you, $n. You helped me see my sister again. For that, I can never repay you.
Veraan is changed. Angry. Tormented by despair. Let us tread delicately.' WHERE `ID`=90852;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Thank you for coming. It is fitting we have you here for this day.' WHERE `ID`=90861;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Elves of all nations have spent ages upon ages drawing upon wells for magic, for life, and for identity. Not even the dragon aspects could surpass our knowledge in this hour.' WHERE `ID`=90862;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Behold the Dawnwell. May its waters never know corruption. May it stand as a reminder of all that we have lost, and an inspiration for what we can become.' WHERE `ID`=90867;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='There we go! Nice and artificial, just like all the best marketing should be.
And I just finished the paperwork for your other big image upgrade. I think you''re really going like this!' WHERE `ID`=90869;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (90869,0,0,0,0,'C''mon, this ain''t rocket surgery. Pick whoever you wanna pose on some magazine covers with.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Ah, ye''ve done it! The cooks will be pleased.' WHERE `ID`=90870;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='It is done. Today marks the first day of the Silversun Compact. May the oaths we sign ourselves to today bind us in trying times to do the right thing.' WHERE `ID`=90871;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (90871,0,0,0,0,'Strange times. Strange times indeed.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Draenei / Â Lightforged draenei / Demon hunters / warlocks / mages with Arcane Linguist
<Tul''amar nods to the freed draenei hiding behind her.>
When we fight, it''s on our terms.
Others
<Tul''amar tilts her head at the freed draenei hiding behind her.>
I see. Good. You good.' WHERE `ID`=90873;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Draenei / Â Lightforged draenei / Demon Hunters / Warlocks / Mages with Arcane Linguist
They want violence? You give them violence. I savored the sight of it.
Those runes look potent. That many should be enough.
Non-draenei
<She counts out the portal runes in your possession and nods in approval.>
Yes. Good.' WHERE `ID`=90874;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Draenei / Â Lightforged draenei
You made this possible, $n. We kin, lost and now reunited. But they must return--and I must be the one to ensure it.
I cannot walk through that portal with them. I must destroy it, to ensure that no domanaar can follow them through and darken our skies as before.
You are my kin. But I cannot trust you with this. I can''t rest until I know they''re safe.
<She then holds her staff forward, offering It to Juras. Though he seems reluctant to take it, Tul''amar does not waver.>
Demon hunters / Warlocks / Mages with Arcane Linguist
You made this possible, $n: my people, safe. They must return, but I must be the one to ensure it.
I cannot walk through that portal with them. I must destroy it to ensure that no domanaar can follow them through and darken our skies as before.
You have proven yourself to be my ally, but I cannot trust you with this. I can''t rest until I know they''re safe.
<She then holds her staff forward, offering It to Juras. Though he seems reluctant to take it, Tul''amar does not waver.>
Non-draenei
Stay. I must. Men of Void, cannot find brothers and sisters. Finish, must. Only I.
You, good. Friend. But. Trust, can''t. Trust. only when brothers and sisters safe.
<She then holds her staff forward, offering it to Juras. Though he seems reluctant to take it, Tul''amar does not waver.>' WHERE `ID`=90875;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='So, we help save the city and in return, I''m allowed to have my old things back.
From anyone else, that would be an insult. From Rommath? The highest of praise.
Oh, he even kept my old alembic... how thoughtful.' WHERE `ID`=90876;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (90876,0,0,0,0,'I am not so filled with pride that I cannot admit to some... mild nostalgia for the banter I once enjoyed with my former peer.
Magister Umbric was once quite the source of counterpoints and suggestions that went beyond expectations, and helped push our knowledge of magic further and further.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Ah, I can smell the pretzels from here. Ye''ve cooked up a spread that''ll keep even the pickiest dwarves satisfied!' WHERE `ID`=90879;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (90879,0,0,0,0,'Get cookin''!',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I''d say ye''ve earned yerself a nice break and a brew after all of yer hard work. But don''t get too relaxed! There''s still plenty to do to keep Brewfest runnin''!' WHERE `ID`=90880;
UPDATE `world`.`quest_template` SET `QuestDescription`='<Good to have you here/Lok''tar>, $n.
<Thrall/Jaina> and I were in the area when we heard reports of a massive gnoll attack on Hammerfall.
We could use your aid eliminating the gnolls here while we aid the wounded and figure out our next move.' WHERE `ID`=90882;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Alliance
Excellent job. However, we cannot rest.
We have word of more chaos in the highlands.
Horde
Fine work. We should keep moving.
There''s more trouble afoot.' WHERE `ID`=90882;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (90882,0,0,0,0,'Handle those gnolls while we figure out our next move.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Just as I thought.
I can barely read any of this.' WHERE `ID`=90886;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='This should help disperse the creatures. Without a leader they''ll flee when Alliance and Horde reinforcements show up.' WHERE `ID`=90887;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (90887,0,0,0,0,'We''ll stay here and guard the remaining farmers while you handle Runk.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='This looks bad, but it''s nothing we can''t handle.' WHERE `ID`=90888;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='<The skies are a little clearer now. The infinites might be interested in trading with this extra bronze I''ve collected.>' WHERE `ID`=90892;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The siege is over. Arathi Highlands will hopefully return to a somewhat peaceful state now.' WHERE `ID`=90896;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (90896,0,0,0,0,'Defeat Ro''grok and end this siege.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='It''s good to see the people here in high spirits.' WHERE `ID`=90897;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='As you gather infinite power do not forget to focus it into your artifact.
The more power you invest, the swifter you will gather more infinite power and grow your artifact''s legend--and your own.' WHERE `ID`=90901;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='My, what delightfully gruesome success.
I am interested to work together with you. You should know more of our people, and see more of my abilities.' WHERE `ID`=90914;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Consider this blade my gift to you. We shall work together to make you into a true weapon of destruction.' WHERE `ID`=90915;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='These Nexus-Points used to be fonts of power for us domanaar to enjoy, long before Xal''atath overthrew us.
Someday, they shall be so again.' WHERE `ID`=90916;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very good.
I understand you mortals fret over things like ecological balance and culling of species.
Fear not: the monsters here are as endless as they are brutal.' WHERE `ID`=90917;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Ah, how quaint, to catch up with old enemies.
We domanaar once had intricate structures of power. Each domanaar fights for their own sake alone, but it is often advantageous to align oneself with others. Temporarily, of course.
The most powerful among us were the High Lords. When Xal''atath arrived... she made an example of them all. The spectacle was so moving, it drew not only fear but something closer to loyalty from us domanaar.
Some, though not all.' WHERE `ID`=90918;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Fascinating, how freely you give up delicate information about yourself.
I choose to believe you would not lie to me, of course. We are friends now, you and I. Such a mortal concept intrigues me.' WHERE `ID`=90920;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I''m terribly sorry you had to go through that. The words of these spirits have upset you, correct?
<Decimus peers at you.>' WHERE `ID`=90922;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The blade, as promised. See? I never meant to keep it for myself. I will even shape it into whichever form suits you best.
The taste of your suffering was all I desired.' WHERE `ID`=90924;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I can provide you with everything you need to explore Untethered Space.' WHERE `ID`=90938;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Is that an outsider''s gear? You were aiding Orweyna with these--distractions, instead of your duties. How will you maintain our traditions if you can not follow my guidance through the ceremony?
I will speak to Elder Hagar. Remember the importance of this day and your duty.' WHERE `ID`=90958;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (90958,0,0,0,0,'Have you performed the tasks that I have asked for?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='In all my years of initiations, this has to be a first. It seems that the Goddess herself has noticed you.
I am sensing a mysterious and bountiful journey ahead of you.' WHERE `ID`=90960;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (90960,0,0,0,0,'Take your time, $n. The ceremony is not about how fast you do it, but about what you learn from it.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='If these rumors are true, we must investigate.' WHERE `ID`=90968;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='<Name>, these consoles are bein'' overloaded by the titan''s presence. If we can defeat them and secure titan discs, I think we can use ''em to empower the console to grant ye boons within the space. The boons can aid you in pushing back these rogue titan constructs.' WHERE `ID`=90969;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Did ye find the shards? While ye were away, I remembered I''d found some on my visit to that location. Ye should find them in a pouch I hid next to the console.' WHERE `ID`=90970;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='My remote console shows that there was a change. The overcharged console is funnelin'' excess energy to a new node. This should grant ye that node''s power when venturin'' intae other areas where the titan constructs have emerged.
We''ll use the titan force''s own energy against ''em!' WHERE `ID`=90971;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very well, we will study this version of the timeline. Let us see what the Illidari hold in their future--err, past.' WHERE `ID`=90995;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (90995,0,0,0,0,'Have you made a choice?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Dagran
Let me see. Yes! The device is powered on.
Okay... If I just start the initialization sequence... and it''s up. There are already two discs inside. And the menu will list areas where other miniature titan discs can be found. I''m thinkin'' I can improve the device, but I need time. Find me later and see.
Oh--before ye go. I was able to gather a few extra items that should help ye on yer future excursions.
Titan Console
Attach the device. Yes! The device is powered on.
Okay... If I just start the initialization sequence... and it''s up. There are already two discs inside. And the menu will list areas where other miniature titan discs can be found. I''m thinkin'' I can improve the device, but I need time. Find me later and see.' WHERE `ID`=91009;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The data from that last excursion provided what I needed for another upgrade. But this is the last upgrade we can do for the belt, unless we want a major meltdown. Of course a meltdown would tell us a lot about the design...
Ma always said, "Dagran! If yer gonna destroy ancient, irreplaceable artifacts, destroy yer own." So this is the last upgrade.
Here is the last upgrade card. Thank ye for yer help. I hope we get a chance to experiment more in the future!' WHERE `ID`=91031;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Their behaviour seems mostly unchanged. This is very frustrating. Also if yer data is correct, it looks like they might be calmin'' down.
We will have tae see if this observation is true. And here is some additional gear that we have collected. I hope it has served ye well over the course of our scientific endeavours!' WHERE `ID`=91033;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Wow! Tha'' drop off is huge. If this holds steady, these constructs could be gone soon!
We still don''t know what prompted them to come out! What if we never know? I hope they return.
Oh no! I don''t want them tae mess things up. I just hate tae leave this unsolved.
At least we will be more prepared if we see them again. Thank ye for yer help, $n. I''ve checked the numbers and yer belt should still work, even if the constructs do retreat.
And one last box of supplies for yer help.' WHERE `ID`=91035;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91035,0,0,0,0,'Do ye have yer results?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='We appreciate your interest in aiding us.
Shards of our timeline have made their way into your world. It is a place more grim and dark than your own, where some villains became heroes and some heroes never had the chance.
Help us locate these hellish fragments out of time and return them to their rightful place, and we will provide you with armors tempered by the fires of our world.
And should you find any Treasure Goblins that lurk in your world, we implore you to slay the abominations.' WHERE `ID`=91038;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='This present looks like it has been shaken a few times. The tag on it reads:
To a very special $r $c.' WHERE `ID`=91041;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='A small tag on this present reads:
Happy holidays, $n!' WHERE `ID`=91042;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I sincerely hope that Adarus is well, and that he doesn''t blame us. The ren'' dorei have enough enemies as it is.
I am excited that Leona has made a breakthrough. Though she never would have succeeded without your help.' WHERE `ID`=91044;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='It is unnerving to not know what has forced these hostile titan units to surface. But due to your efforts their threat is at an end.' WHERE `ID`=91052;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91052,0,0,0,0,'How goes your dangerous exploration?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You are braver than I thought, $n.
Please continue to experiment. I will not let us enter dangerous futures unprepared.' WHERE `ID`=91061;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Ah, I can smell the pretzels from here. Ye''ve cooked up a spread that''ll keep even the pickiest dwarves satisfied!' WHERE `ID`=91066;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Ah, ye''ve done it! The cooks will be pleased.' WHERE `ID`=91067;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I''d say ye''ve earned yerself a nice break and a brew after all of yer hard work. But don''t get too relaxed! There''s still plenty to do to keep Brewfest runnin''!' WHERE `ID`=91068;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Do you hear dat?
It''s quiet.
Dat is de sound of vengeance.' WHERE `ID`=91069;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Good. That''s all of it.' WHERE `ID`=91070;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I saw de small ones run away in terror. Well done, $c.' WHERE `ID`=91071;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Is it done? Thanks. It won''t bring Ja''kul back, but now they won''t be hurting anyone else.' WHERE `ID`=91086;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Whew! Good riddance.
I cannae stand all tha skulking around and teleportin'' about tha place.
Might be time for a wee bit of vacation after all this excitement.' WHERE `ID`=91089;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='That wasn''t so bad, was it?
Val does get a bit dramatic, but you performed wonderfully.' WHERE `ID`=91090;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You smell like a fireplace. I hope he wasn''t too much of a challenge for you?' WHERE `ID`=91095;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Tormenting our guests was a step too far.
She encroached on the sunbath and has paid the price for her actions.
Thank you, new friend of the Solaar family!' WHERE `ID`=91137;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Ah yes. I can sense the change in you. The growth that comes with meting out death in one hand, while nuturing life in the other.
Perhaps this small token will serve as a reminder of T''uure and his role in Dimensius'' ultimate fate.' WHERE `ID`=91138;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91138,0,0,0,0,'Have you demonstrated your own creative and destructive natures, priest?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='A fragment of the lost naaru T''uure? And lodged in the form of Dimensius?
Now this is something I never thought I''d see.' WHERE `ID`=91140;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91140,0,0,0,0,'What is this? Ah, I see now. You were right to come to me.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='She''s hurting him, throwing him into fight after fight. We don''t have time to search this whole blasted plain.
I can''t concentrate. The Void magic here is too chaotic and volatile.' WHERE `ID`=91146;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91146,0,0,0,0,'He''s strong. Whatever she tries, he''ll survive. He has to.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Removing the Shadowgrafts kills them... What good is the Light if it can''t save one man?' WHERE `ID`=91147;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91147,0,0,0,0,'Bending other creatures to her whims? This domanaar is a twisted beast. We''ll put her down.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I had him. One spear thrust and I could have ended it... but he''s still Cal--even with that monster controlling him.
<Anais clutches at ragged cut in her side. Blood and foul Void magic flow from the wound in equal measure.>
Look what chasing after him again got me.' WHERE `ID`=91148;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91148,0,0,0,0,'...',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I felt it. When you--when he--thank you. Sorry. Getting hard to think.
<She accepts the tinder box and holds it to her chest. Her eyes seem to focus on something you can''t see.>
Cal...? I''m so tired. Let''s go home.
<Anais slumps over, her hand falling away from the wound at her side. She is at peace.>' WHERE `ID`=91149;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You''ve bought us a moment of peace.
Rest well, but always keep your blade sharp.' WHERE `ID`=91173;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91173,0,0,0,0,'Ready yourself soldier, the battle is still to come.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Thank you for your contributions.' WHERE `ID`=91197;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Wow... I can''t believe I actually got all three recommendations. They all said such kind things, but now I feel even more torn than before!
Do you think... perhaps you could help me choose?' WHERE `ID`=91284;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Well now, look at that. Clean cuts, no mess... maybe the kid''s got more fire than I thought.
Here, take this recommendation. Tell them a Farstrider never forgets who earns their place--and to keep their aim sharp. We''ll be watching.' WHERE `ID`=91288;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Hmm, it seems you have a bit more talent than I anticipated.
This staff is properly charged. Well done, though I''m sure you barely broke a sweat.
Take this recommendation, and remember--the arcane demands respect, not just power.' WHERE `ID`=91292;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Ah... so the boy has chosen at last. He has heart--too much perhaps.
Yes. This will be recorded and honored. You''ve done more than deliver a message--you''ve helped shape a life. Thank you.' WHERE `ID`=91301;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Magic! Perfection! You could not be more skilled if I had wished you into existence.
That is an interesting thought. Could I have?' WHERE `ID`=91328;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Normally, I would refuse the intervention of an outsider without a second thought... but given the situation, perhaps you can be of some help.' WHERE `ID`=91375;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Truth chosen
It is unfortunate that the beast turned out to be as pitiful and lame as you mortals.
You deserve each other.
Lie chosen
Fidoficus will grow so terribly large, that it is he who will be walking you.
Only then will he be worthy of joining me as my attack behemoth.' WHERE `ID`=91382;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='My rangers are earning their keep today, that''s for certain.' WHERE `ID`=91383;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='This is a good start. All it takes is a handful of us putting in a little effort.' WHERE `ID`=91384;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The legends are real... Eversong must be pleased with us!' WHERE `ID`=91385;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='All right... but only because I''m curious about the craftsmanship.
It''ll take more than a little politeness to change my mind about these pernicious paladins.' WHERE `ID`=91386;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Ah... beautiful, glittering manasilk. So ripe with potential.' WHERE `ID`=91388;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='It is a thing of beauty... I am glad to know it is in the hands of someone who loves it so.' WHERE `ID`=91389;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91389,0,0,0,0,'...',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Hey, dat''s a spider fang. Dat must have been one huge spider!' WHERE `ID`=91404;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='All de places dey mentioned are right next door to Shadra''Alor! Dey probably worshipped Shadra.
We can''t trust dem. Dey are like de venoms dey use. Dey will poison de rest of de tribe against de Revatusk--against us all!' WHERE `ID`=91406;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='De spiders fled? I thought dey would put up more of a fight. And you said dey were small? Hm.
Well, it doesn''t matter. Halazzi has set us on this hunt now. We need to see it through.' WHERE `ID`=91407;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='This is de Shadra I remember from Shadra''Alor. She will assist us if we help her.
She keeps her promises.' WHERE `ID`=91409;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I can''t imagine dat was easy. Halazzi must have blessed your hunt.' WHERE `ID`=91411;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Those people fight so hard for us. We must do all we can to protect them.' WHERE `ID`=91417;
UPDATE `world`.`quest_template` SET `QuestDescription`='ZiadanÂ says: The gravitational forces here can provide extra power. Go use it to eliminate some of the ethereals.' WHERE `ID`=91419;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='ZiadanÂ says: The job is done.' WHERE `ID`=91419;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='<Om''myuz takes a closer look at the ore.>
That is quite the intriguing rock you''ve found. I would like to inspect it further, and any others you find. What say you to a trade?
Other Cartel Om members in the Veiled Market may also be interested in trading wares, should you come across them.' WHERE `ID`=91420;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='We did good work out there, $n. That''s all we can ever hope for.' WHERE `ID`=91426;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The power you and your artifact possess were able to halt a Legion invasion. But was it you, or the artifact you wield, that is responsible? On that I will require more information.' WHERE `ID`=91439;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Your name is on the minds of the people, and is shared around the fire. The greater your legend becomes, the more powerful your name will be. But does the power of one''s name eclipse that of the artifact they wield? This is the burning question.' WHERE `ID`=91440;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Just as I predicted. You were able to stop a massive Legion invasion. It was not you, or your artifact that did this. Rather it was the combination of both that won the day.' WHERE `ID`=91441;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Well done, $n. Moratari will be overjoyed to see these new data points.' WHERE `ID`=91443;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Well done, $n. Moratari will be overjoyed to see these new data points.' WHERE `ID`=91447;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91447,0,0,0,0,'We need more fight data to complete our study, and time is running short.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='A fascinating outcome, $n. This will shed some much needed light on our research.' WHERE `ID`=91448;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Well done, $n. Moratari will be overjoyed to see these new data points.' WHERE `ID`=91449;
UPDATE `world`.`quest_template` SET `QuestDescription`='Astalor BloodswornÂ says: Do not end them yet. Savor the hunt, and let the artifact consume their fear.' WHERE `ID`=91458;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Astalor BloodswornÂ says: Such wonderful terror.' WHERE `ID`=91458;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='That certainly qualifies as high-ranking, $n! After I work my magic, that translocator is as good as ours. Next stop, enemy territory!' WHERE `ID`=91459;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91459,0,0,0,0,'Have you found credentials we can use to enter the translocator?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='That certainly qualifies as high-ranking, $n! After I work my magic, that translocator is as good as ours. Next stop, enemy territory!' WHERE `ID`=91460;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91460,0,0,0,0,'Have you found credentials we can use to enter the translocator?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='That certainly qualifies as high-ranking, $n! After I work my magic, that translocator is as good as ours. Next stop, enemy territory!' WHERE `ID`=91461;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91461,0,0,0,0,'Have you found credentials we can use to enter the translocator?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='It''s a good thing we came. There are more mana wyrms here than usual.' WHERE `ID`=91462;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I-I''m not worried. This is what being a Farstrider is all about!' WHERE `ID`=91463;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='...' WHERE `ID`=91467;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91467,0,0,0,0,'...',0);
UPDATE `world`.`quest_template` SET `QuestDescription`='Astalor BloodswornÂ says: Do not end them yet. Savor the hunt, and let the artifact consume their fear.' WHERE `ID`=91595;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Astalor BloodswornÂ says: Such wonderful terror.' WHERE `ID`=91595;
UPDATE `world`.`quest_template` SET `QuestDescription`='Astalor BloodswornÂ says: Do not end them yet. Savor the hunt, and let the artifact consume their fear.' WHERE `ID`=91596;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Astalor BloodswornÂ says: Such wonderful terror.' WHERE `ID`=91596;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very good. The Horde is filled with such hateful, violent souls.' WHERE `ID`=91599;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91599,0,0,0,0,'...',0);
UPDATE `world`.`quest_template` SET `QuestDescription`='Astalor BloodswornÂ says: Let your prey believe you''re blind to their strike, then make them regret every misstep.' WHERE `ID`=91601;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Astalor BloodswornÂ says: They will retreat to lick their wounds, and then we will cut them deeper.' WHERE `ID`=91601;
UPDATE `world`.`quest_template` SET `QuestDescription`='Astalor BloodswornÂ says: Let your prey believe you''re blind to their strike, then make them regret every misstep.' WHERE `ID`=91602;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Astalor BloodswornÂ says: They will retreat to lick their wounds, and then we will cut them deeper.' WHERE `ID`=91602;
UPDATE `world`.`quest_template` SET `QuestDescription`='Astalor BloodswornÂ says: Let your prey believe you''re blind to their strike, then make them regret every misstep.' WHERE `ID`=91604;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Astalor BloodswornÂ says: They will retreat to lick their wounds, and then we will cut them deeper.' WHERE `ID`=91604;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='So Charonus is our enemy. I am unsurprised. He always scraped together power through whatever means necessary, even stooping so low as to bow and scrape to Xal''atath. Disgraceful.
Nonetheless, let us hear their proposition.' WHERE `ID`=91606;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='<Name>, you have been an excellent assistant with our research. I think you deserve a promotion.
From now on, you will be able to take on more research assignments simultaneously.
It''s ironic, isn''t it, that we never seem to have enough time. Make good use of your time here. Don''t make me regret granting you this power.' WHERE `ID`=91613;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Excellent, Archdruid. These will do nicely.' WHERE `ID`=91614;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91614,0,0,0,0,'Were you able to find the Blood of Sargeras?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='At last, I have enough Blood of Sargeras to fuel my creations! You will see, Deathlord, what my genius is truly capable of creating...
Now, I must ask that you leave me to my work... there is much to do, and we have little time to waste!' WHERE `ID`=91615;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91615,0,0,0,0,'Blood is the fountain of life and the fuel of my creations. Unfortunately, Deathlord, my supply is running low and the quality as of late has been disappointing at best.
If my undead offspring are to reach their full potential, I will need pure blood of the highest quality. Bring me the Blood of Sargeras and I will use it to fuel my finest creations!
[Blood of Sargeras] (5)',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='This should do.' WHERE `ID`=91616;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91616,0,0,0,0,'The enchanting process cannot be completed without the proper reagents.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You got them! Now to upgrade your barding.
Never say a blacksmith can''t improve on a leatherworker''s work, I always say. I mean never. I mean... well you know what I mean.' WHERE `ID`=91618;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91618,0,0,0,0,'I doubt you''ll have a problem getting the leystone, but the sapphire might be a bit harder to acquire.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Yes, this is just what we need to complete our preparations. These must have been difficult to come by. Thank you, Highlord.' WHERE `ID`=91619;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91619,0,0,0,0,'Have you acquired any Blood of Sargeras?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='<Ma''haat the Indomitable guzzles the Blood of Sargeras down his throat as he speaks.>
Yesh... thish ish... just what I wanted. The egg ish... yoursh!' WHERE `ID`=91621;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91621,0,0,0,0,'Such an egg is quite precious, fleshling. Yet, my hunger gnaws so deep...
Such a barter will cost you... greatly.
Bring me 5[sic] Blood of Sargeras, and I will give you the egg.
[Blood of Sargeras] (3)',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Ah, so the rumors are true about your efficiency.
Excellent. Now we can begin the game.' WHERE `ID`=91628;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I will have my valet send for them at once.' WHERE `ID`=91629;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='They must mean to weaken us and our ability to commune with Shadra.' WHERE `ID`=91630;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Your power grows stronger, $n.
Please, take this token of our gratitude for your assistance with our research. Let it echo with every you that exists in the fractures of this timeline.' WHERE `ID`=91631;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You have reached your full potential, $n. Or have you? Perhaps this is only the beginning of your journey through this epoch.
Please, take this token of our gratitude for your assistance with our research. Let it echo with every you that exists in the fractures of this timeline.' WHERE `ID`=91632;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You have grown stronger, but your artifact is stronger yet.
It would appear that my hypothesis holds true--artifacts appear to be the key to protecting Azeroth.' WHERE `ID`=91639;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Splendid.
I dearly hope you find some time to enjoy yourself while court is in season. While I do appreciate the sullen, results-driven sort, you could stand to smile.' WHERE `ID`=91693;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I feel much safer knowing those threats have been eliminated.' WHERE `ID`=91700;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I admit. I am pleasantly surprised to be proven wrong. Your power has grown and I cannot say with certainty which is the greater. You, or the weapon you wield.' WHERE `ID`=91721;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Humbling.
It is the very nature of finite existence that is the answer.
Mortality is the flame that shines brightest because it is free to choose a single moment of glory, rather than be burdened by the weight of eternity.
Choose your moment well, $n, and nothing, not even time, will be able to stop you.' WHERE `ID`=91722;
UPDATE `world`.`quest_template` SET `QuestDescription`='Magister UmbricÂ says: The cult continues to recruit the innocent with promises of power. Their evil ends now.' WHERE `ID`=91779;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Magister UmbricÂ says: Hopefully more learn the lesson you have given the cult today.' WHERE `ID`=91779;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Good tae see ye! We''ve got plenty tae discuss.' WHERE `ID`=91780;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Right, on to that wee problem I mentioned.' WHERE `ID`=91781;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I can''t believe it was a ruse all along.
A shame about the curios, but at least ye got me britches back!' WHERE `ID`=91782;
UPDATE `world`.`quest_template` SET `QuestDescription`='Elder HagarÂ says: Lightbloom spores are spilling out of The Blinding Bloom. Get rid of them before they spread.' WHERE `ID`=91785;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Elder HagarÂ says: Good work. We may be fighting this battle for some time, but you''ve helped stem the flow.' WHERE `ID`=91785;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='These champions of the Twilight''s Blade are just as foolhardy as the other members of the cult. We will cut them all down, in time.' WHERE `ID`=91795;
UPDATE `world`.`quest_template` SET `QuestDescription`='LilajuÂ says: Our village was raided by de Twilight''s Blade. We need to replenish our food stores. You any good at hunting?' WHERE `ID`=91798;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='LilajuÂ says: Not bad. These look fresher than what de furbolg trade with us. Accept this as de Revantusk''s thanks.' WHERE `ID`=91798;
UPDATE `world`.`quest_template` SET `QuestDescription`='Torundo the GrizzledÂ says: With Akil''zon back, we reclaim our old traditions. Join us at de temple for our trial of flight!' WHERE `ID`=91799;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Torundo the GrizzledÂ says: You are a natural, hash''ura! It''s a glorious feelin'' to soar with de eagles, yes?' WHERE `ID`=91799;
UPDATE `world`.`quest_template` SET `QuestDescription`='LilajuÂ says: De Twilight''s Blade be ransacking our villages, takin'' priceless relics. Get ''em back!' WHERE `ID`=91800;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='LilajuÂ says: You''ve returned our heirlooms and our relics. Thank you, hash''ura--from de Revantusk, and our ancestors.' WHERE `ID`=91800;
UPDATE `world`.`quest_template` SET `QuestDescription`='Zul''jarraÂ says: Twilight''s Blade be hidin'' out at Speaker''s Rest. Show them how a hash''ura protects Zul''Aman!' WHERE `ID`=91801;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Zul''jarraÂ says: You got dem handled, $n. Now there be fewer Twilight left in our lands thanks to you.' WHERE `ID`=91801;
UPDATE `world`.`quest_template` SET `QuestDescription`='Torundo the GrizzledÂ says: Our beasts favor bloodthirsty insects from de Leech Bog. Help us gather more for de hunt.' WHERE `ID`=91802;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Torundo the GrizzledÂ says: Many thanks, hash''ura. You saved dis old man a lot of work. And a lot of bug bites!' WHERE `ID`=91802;
UPDATE `world`.`quest_template` SET `QuestDescription`='Zul''jarraÂ says: De murlocs are ambushin'' our supply carts. Descend upon dem and take back what dey stole.' WHERE `ID`=91803;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Loa Speaker KinduruÂ says: You got de supplies back and sent dem on de run! good job, $n.' WHERE `ID`=91803;
UPDATE `world`.`quest_template` SET `QuestDescription`='Loa Speaker BreakÂ says: De Children of fire seek fresh food! Swim! Dive! Hunt! Find us many fish to feast upon!' WHERE `ID`=91804;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Loa Speaker BrekÂ says: Children of fire are satisfied! Mother of flames is smilin''! De rain of fish has come dis day!' WHERE `ID`=91804;
UPDATE `world`.`quest_template` SET `QuestDescription`='Torundo the GrizzledÂ says: Many are still recoverin'' from de Twilight''s Blade attack. Help us gather herbs ''round de Shrine of Kulzi for medicine.' WHERE `ID`=91805;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Torundo the GrizzledÂ says: Praise Kulzi. De stems and roots you bring will give relief to all de wounded in our care.' WHERE `ID`=91805;
UPDATE `world`.`quest_template` SET `QuestDescription`='Kul''amara the FierceÂ says: Gnarldin be attacking our hunting parties, stealing from us. Hit dem back and retrieve what ya can.' WHERE `ID`=91806;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Kul''amara the FiercedÂ says: Many thanks. Maybe now de gnarldin will learn to hunt their own hills instead of de Witherbark''s.' WHERE `ID`=91806;
UPDATE `world`.`quest_template` SET `QuestDescription`='Kul''amara the FierceÂ says: De Twilight''s Blade are sabotaging'' our lumberyard again! Save what lightwood you can find and hit dem back--hard.' WHERE `ID`=91808;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Kul''amara the FierceÂ says: Good. Real good. You put de fear of de forest tribes back in dem.' WHERE `ID`=91808;
UPDATE `world`.`quest_template` SET `QuestDescription`='Torundo the GrizzledÂ says: De tortollans offered us meals to help with the refugees. Mind checking if it be edible?' WHERE `ID`=91810;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Torundo the GrizzledÂ says: Hm. Well ya ain''t dead from it. So.. I''d call dat edible enough!' WHERE `ID`=91810;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='We meant no harm. We wanted to talk about Nalorakk.
A bear showed up that says it speaks for our loa, but it feels wrong.
Maybe with your help, we can sniff out a solution.' WHERE `ID`=91813;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Hmm, burning that pamphlet produced a very peculiar reaction from the flames.
<Moratari begins taking notes, completely ignoring you.>' WHERE `ID`=91821;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Well done. The less they know, the safer our people are.' WHERE `ID`=91823;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Good. With these back where they belong, their reach just got a lot shorter. I only wish we''d uncovered who took them originally.' WHERE `ID`=91824;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Excellent. All of their most important secrets, out of their hands.' WHERE `ID`=91825;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='This is vital information. No wonder they went to such lengths to protect it.' WHERE `ID`=91826;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='<Lor''themar examines the documents carefully. After a moment, he looks up at you and allows a faint smile.>
Excellent work. I knew I could count on you both.' WHERE `ID`=91827;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I''ve been watching the path. Movement''s light, at least for now.' WHERE `ID`=91828;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91828,0,0,0,0,'Yes?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Clean work. The kind they don''t come back from.' WHERE `ID`=91829;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91829,0,0,0,0,'Keep the kills quiet if you can.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Now this is useful. Let''s see how well their little operation runs when they''re chasing ghosts and missing crates.' WHERE `ID`=91830;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91830,0,0,0,0,'The right scrap of parchment can win a war. Or start one.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='That should be all of them.' WHERE `ID`=91831;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91831,0,0,0,0,'Ready yourself. This might get messy.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='<Name>, you have been an excellent assistant with our research. I think you deserve a promotion.
From now on, you will be able to take on more research assignments simultaneously.
It''s ironic, isn''t it, that we never seem to have enough time. Make good use of your time here. Don''t make me regret granting you this power.' WHERE `ID`=91846;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You are a credit to heroes everywhere. Thank you.' WHERE `ID`=91855;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Congratulations on acquiring your new house. We know you''ll be very happy here and we look forward to seeing you around the neighborhood.' WHERE `ID`=91863;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91863,0,0,0,0,'Have you found your forever home?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I lived far longer before I became Rootwarden than after.
Yet Teldrassil will always be what defines my life.' WHERE `ID`=91872;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Thank you for helping to protect what may still live of Teldrassil.
It may be that nothing remains--some of these roots still smolder.
Yet I vowed to serve as Rootwarden, and I will not fail a second time, if there is any hope. I choose each day to believe there may be, that Teldrassil could bloom again.
Though I may only be preserving her memory.' WHERE `ID`=91873;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='$n, the smell of smoke fills me with the same dread I felt on that terrible day.
There is much heat still trapped within the largest roots, and in the right circumstances, the burning begins anew.
If we have any hope of seeing the roots restored one day, we have to be vigilant against even small fires.' WHERE `ID`=91874;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='This will do nicely, for today. One moment while I mix it with these reagents.' WHERE `ID`=91875;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Thank you, $n, for your help.
Because of you, I was able to keep up my routines even with those fires.
Perhaps one day, we might see a sprout--even if it takes many years.
And I shall be ever ready to resume my duties as Rootwarden, should hope bloom.' WHERE `ID`=91876;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I am better now... stable, but a fatigue still clings to me.
If we''re to find your scouts, I will need your help.' WHERE `ID`=91885;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='That''s all of them. Good work.' WHERE `ID`=91918;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91918,0,0,0,0,'Steady now.',0);
UPDATE `world`.`quest_template` SET `QuestDescription`='AmarakkÂ says: Lesser manifestations escape from the rift. Send them back where they belong.' WHERE `ID`=91927;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='AmarakkÂ says: Good work. They fell back to the Rift in glorious rain.' WHERE `ID`=91927;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Quite acceptable!
You may yet prove a glorious addition to the acolytes of abundance.' WHERE `ID`=91932;
UPDATE `world`.`quest_template` SET `QuestDescription`='OrweynaÂ says: Brann asked to have you document the creatures of Harandar. You can borrow this beast to travel swiftly.' WHERE `ID`=91937;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='OrweynaÂ says: Brann is very interested in my homeland, and I''m certain he will be impressed.' WHERE `ID`=91937;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='We noticed this large creeper tracking you out in the wastes, but when it emerged it made no aggressive moves whatsoever. Judging by its reaction to your arrival, I believe you''re the one its been looking for. You''re becoming quite popular, no?' WHERE `ID`=91954;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Success!
It''s almost a shame to destroy such a beautiful replica.
But you have the real thing, so I say scrap it and rejoice at the bounty of beautiful bronze!' WHERE `ID`=91955;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='A place for everything and everything in its place.' WHERE `ID`=91968;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Excellent work! It''s looking more like a home already.
And while I could spend millennia teaching you everything I know, I believe one learns best by doing.
Never stop designing. Never stop creating!' WHERE `ID`=91969;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You have successfully blunted those Twilight tools. Whether or not we will have any takers for this odd assortment of tokens is yet to be determined.
There is, however, no accounting for taste.' WHERE `ID`=91971;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91971,0,0,0,0,'Have you found anything useful?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='An uneventful watch is more rewarding than an empty conversation.
The Blood Knights appreciate your service.' WHERE `ID`=91972;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Anar''anel belore! You love to hear it. This news is sure to warm a few hearts for our cause.' WHERE `ID`=91974;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Your task is done. These will prove useful.
Do not let on that the Blood Knights got first pick.' WHERE `ID`=91975;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91975,0,0,0,0,'Did you gather the lightwood?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You have performed well. Silvermoon appreciates your service.
I would have happily swapped places with you, but we all have our assignments.' WHERE `ID`=91976;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Ah, that must have been such fun! My bar may be lower today, after the engrossing discourse on the harvesting cycle of the basic peacebloom.
Apologies. Know your service is appreciated.' WHERE `ID`=91977;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91977,0,0,0,0,'Have you taught the Tideborne a lesson?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='One must appreciate the special jingle of a heavy sack of purloined coins.
Excellent work, my friend.' WHERE `ID`=91978;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Good work. I''m sure that will make for some excellent kindling.' WHERE `ID`=91979;
UPDATE `world`.`quest_template` SET `QuestDescription`='AmarakkÂ says: $n, I am in need of more venom and also more healing water. Since you are in the Ahl''ua Weltand, would you do me this favor?' WHERE `ID`=91981;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='AmarakkÂ says: Thank you, $n. Your aid in Harandar continues to bring you great honor.' WHERE `ID`=91981;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Perfect! I have to confess, it will be hard to give some of this up.
I must remember, I have a job to do here. It can''t all be fun and games.
Your work is appreciated.' WHERE `ID`=91984;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91984,0,0,0,0,'Oh, did you get all of the silk?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I asked for unusual and you delivered! A couple of these seem a bit... suspect.
I''m sure it will be fine. What could go wrong with items of mysterious origin?' WHERE `ID`=91985;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91985,0,0,0,0,'Did you find anything interesting?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I feel bad for the snapdragons, but I can''t help but laugh at the look of surprise on their face when their little buddies pounce on them.
Thank you for making the day a little more entertaining.' WHERE `ID`=91986;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91986,0,0,0,0,'Are the naga adequately harassed?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The results of sharing these with the Silvermoon elite could range from passably amusing to disastrous.
Either way, I look forward to seeing the results of their gardening efforts.' WHERE `ID`=91987;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91987,0,0,0,0,'Any problems with the harvest?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='It makes everyone happy to have all the creatures home at Brightwing. Having a peaceful place to enjoy the coast is a benefit to all.
Thank you for letting Cerul enjoy a little play time!' WHERE `ID`=91988;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Joy! These will bring much excitement, and some chagrin, to the court.
Many thanks! Oh, and $n... be sure to cleanse your hands before you rub your eyes--or worse. I learned that the hard way.' WHERE `ID`=91989;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Best of luck to our little nudibranchian friends! Yes, I made that word up, but is it not accurate?
Thank you for helping them seek out more pleasant waters.' WHERE `ID`=91990;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Perfect! This is just what the court ordered.' WHERE `ID`=91991;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91991,0,0,0,0,'Did you find the cask?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The wine attacked you both, you say? Ah yes, I suppose the mana in that particular vintage is prone to sedimentation.
I am pleased most of it was recoverable.' WHERE `ID`=91992;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91992,0,0,0,0,'I dearly hope my apprentice has a colorful excuse for his tardiness.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Oh, they are positively precious, are they not?
I imagine we will see quite a few miniscule toads in handbags this coming season.' WHERE `ID`=91993;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Marvelous. I am certain our guests would have preferred to see the battle themselves, but tales of your heroism will do nicely.' WHERE `ID`=91995;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Mana silk has a beautiful sheen, does it not?
The Magisters will be looking spectacular throughout the soiree.' WHERE `ID`=91996;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91996,0,0,0,0,'Do be careful around the mana wyrms. I understand they can be aggressive after harvesting.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='We will have the estate shining in no time.' WHERE `ID`=91997;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91997,0,0,0,0,'Technically any broom would do, but the magic is easier to weave if the object has already been primed to receive the enchantment.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You look properly covered in mud and grime. Have you done it?
Ah yes, these are his vines. Well done.' WHERE `ID`=91998;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91998,0,0,0,0,'Be careful Muckmire doesn''t drag you into the mud with him.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Nice haul. You''ve got a good eye for this stuff.
If you''re ever looking for work after this thing''s over, let me know.' WHERE `ID`=91999;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91999,0,0,0,0,'Trust me. I know how to keep nobles happy.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The energy''s high, the drinks are flowing, and people are having a good time!

That''s how you start making deals.' WHERE `ID`=92000;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='If there''s anything good in these crates, we''ll get it on the market.' WHERE `ID`=92001;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (92001,0,0,0,0,'I don''t mind competitors, but I don''t like the deals those smugglers are making.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Nice work. Eversong is safer because of your heroism, and I get to pocket a little more gold. I''d call that a win-win.' WHERE `ID`=92002;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I told you they were flashy!

Sounds like the enchantment could get tuned down a little bit, but where''s the fun in that?' WHERE `ID`=92003;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Excellent. That''s enough to restock what I''ve sold and then some.

Oh, by the way, you probably want to wash your hands. Maybe a few times.' WHERE `ID`=92004;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (92004,0,0,0,0,'Were you able to find any of those frogs?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Oh, that smell is... very fishy. Definitely going to let these dry out for a while.

Your exceptionally efficient help is appreciated, .' WHERE `ID`=92005;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (92005,0,0,0,0,'Any luck finding some of those fangs?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Nice work. I''ll see about getting those casks refilled, but these bottles should keep everyone happy in the meantime.' WHERE `ID`=92006;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (92006,0,0,0,0,'Trust me. Everything on that list is fantastic.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Look at that. Everyone comes out a winner!

The noble gets his valuable back unscathed, Seridis gets paid handsomely, and you and I look brave and capable in front of the soiree.' WHERE `ID`=92007;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (92007,0,0,0,0,'Making friends with the servants in noble households opens up a lot of doors. Sometimes literally.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='There you have it! Eight flowers. Simple enough, no? Now, I just need a few more things...

What? I didn''t mention that there would be a shopping list? Oh, bother. Well, nothing to it but to do it now, hrm? You don''t seem the type to leave things half-handled.' WHERE `ID`=92021;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='There we are. See? I knew I could rely on you. We''ve only a few steps left to manage.' WHERE `ID`=92022;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I... I owe you my life, , but that look on your face tells me you''re here for something else.

I must have been dreaming of Alora, she was my cell mate in that accursed world the demons took me to. She told me she saw the crystal but never said much else.

I just hope she is still alive.' WHERE `ID`=92024;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Goodness! That was nearly quite the misunderstanding. I am glad you stayed your weapons long enough to hear me out.

The Scourge took much from the sin''dorei. For some, like Amalthea, it took everything and more.

Needless to say, my studies don''t get me invited to many parties. But they allow me, from time to time, to ease Amalthea''s torment. To that end, I would bear any indignity.' WHERE `ID`=92025;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Hero! Your reputation for topping tyrants precedes you. Let''s see about adding one more to that list.' WHERE `ID`=92031;
UPDATE `world`.`quest_template` SET `QuestDescription`=':' WHERE `ID`=92062;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`=':' WHERE `ID`=92062;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You''re back already! I believe I''ve found a use for the Manaforged Instruments you may have found within Araz''s possession. Each are pieces of machinery that, if extracted properly, would yield a unique energy signal not dissimilar to the magic used to bind Ethereals. If you or anyone you know are particularly well-versed in Enchantmenting or Inscription, take these! They may hold secrets, or at the very least a novel experience for you. Good luck!' WHERE `ID`=92078;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Hero... far be it from me to question your methods in taking down the All-Devouring, but I''ve noticed your snooping while inside Omega. Those cyphers you discovered are how we communicate with our contacts inside. I don''t even know how you activated them - they were supposed to be heavily encrypted! Still... this is the kind of mischief I love to encourage. I''m not sure what use you''ll get out of this disguise, but for all you''ve done for us, you''ve earned a treat. Just don''t say you got it from me.' WHERE `ID`=92082;
UPDATE `world`.`quest_template` SET `QuestDescription`=':' WHERE `ID`=92085;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`=':' WHERE `ID`=92085;
UPDATE `world`.`quest_template` SET `QuestDescription`=':' WHERE `ID`=92105;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`=':' WHERE `ID`=92105;
UPDATE `world`.`quest_template` SET `QuestDescription`=':' WHERE `ID`=92119;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`=':' WHERE `ID`=92119;
UPDATE `world`.`quest_template` SET `QuestDescription`=':' WHERE `ID`=92120;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`=':' WHERE `ID`=92120;
UPDATE `world`.`quest_template` SET `QuestDescription`=':' WHERE `ID`=92121;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`=':' WHERE `ID`=92121;
UPDATE `world`.`quest_template` SET `QuestDescription`=':' WHERE `ID`=92122;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`=':' WHERE `ID`=92122;
UPDATE `world`.`quest_template` SET `QuestDescription`=':' WHERE `ID`=92138;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`=':' WHERE `ID`=92138;
UPDATE `world`.`quest_template` SET `QuestDescription`='...' WHERE `ID`=92139;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='...' WHERE `ID`=92139;
UPDATE `world`.`quest_template` SET `QuestDescription`=':' WHERE `ID`=92140;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`=':' WHERE `ID`=92140;
UPDATE `world`.`quest_template` SET `QuestDescription`=':' WHERE `ID`=92141;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`=':' WHERE `ID`=92141;
UPDATE `world`.`quest_template` SET `QuestDescription`=':' WHERE `ID`=92143;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`=':' WHERE `ID`=92143;
UPDATE `world`.`quest_template` SET `QuestDescription`=':' WHERE `ID`=92144;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`=':' WHERE `ID`=92144;
UPDATE `world`.`quest_template` SET `QuestDescription`=':' WHERE `ID`=92146;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`=':' WHERE `ID`=92146;
UPDATE `world`.`quest_template` SET `QuestDescription`=':' WHERE `ID`=92149;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`=':' WHERE `ID`=92149;
UPDATE `world`.`quest_template` SET `QuestDescription`=':' WHERE `ID`=92152;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`=':' WHERE `ID`=92152;
UPDATE `world`.`quest_template` SET `QuestDescription`='None.' WHERE `ID`=92153;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='None.' WHERE `ID`=92153;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Well done with Havazza. I hated the idea that she''d get away from this without any consequences.

On the positive side, I can learn a lot from this entity for future disturbances.' WHERE `ID`=92159;
UPDATE `world`.`quest_template` SET `QuestDescription`=':' WHERE `ID`=92162;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`=':' WHERE `ID`=92162;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Are you finished?

I mean, it is finished. The Deepfin shall trouble us no more!' WHERE `ID`=92164;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Witness the power of my champion! Be fed, my people, and hunger no more!' WHERE `ID`=92165;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You found her! Thank you! Erm, I mean... the Loa of Murlocs grants you favor. champion.' WHERE `ID`=92166;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='While you collect more anguish, I will experiment with this power''s potential.' WHERE `ID`=92177;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Aggression is simply an expression of strength.

So long as we are the predator, not the prey.' WHERE `ID`=92180;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (92180,0,0,0,0,'My work here will make the world fear Silvermoon''s might.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='There will always be some who resist progress, but no matter the cost, my studies in anguish are for the people of Silvermoon.' WHERE `ID`=92181;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (92181,0,0,0,0,'In all of my endeavors, there are always some who seek to impede my progress.',0);
UPDATE `world`.`quest_template` SET `QuestDescription`=':' WHERE `ID`=92195;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`=':' WHERE `ID`=92195;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Good work. Now for the hard part.' WHERE `ID`=92397;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The runestone hums with power again thanks to you. You have my appreciation.' WHERE `ID`=92398;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Oh nice! Yeah this is perfect.

Thank you so much!' WHERE `ID`=92402;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (92402,0,0,0,0,'Did you get a chance to pick up those crystals yet?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Excellent work, I''m sure we''ll discover more anomalies hiding about, but with your help we''ve eliminated any immediate threats.' WHERE `ID`=92407;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You will find no higher quality of manasilk in all of Eversong, let alone the world.' WHERE `ID`=92408;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Thank you so much!

I can get the rest of this food ready now, you really are the best!' WHERE `ID`=92417;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (92417,0,0,0,0,'Please hurry back with the ingredients!',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Let''s see what we can do with it!' WHERE `ID`=92429;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (92429,0,0,0,0,'Thanks for your help on this. I''m really excited to see if I can make this work.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Excellent timing, . Now the research can begin.' WHERE `ID`=92430;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Impressive. I can sense your power. This is a most critical addition to our research.' WHERE `ID`=92439;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Impressive. I can sense your power. This is a most critical addition to our research.' WHERE `ID`=92440;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Impressive. I can sense your power. This is a most critical addition to our research.' WHERE `ID`=92441;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (92441,0,0,0,0,'Remember to pace yourself, the journey is just as important as the destination.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Impressive. I can sense your power. This is a most critical addition to our research.' WHERE `ID`=92442;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Thanks for helping me out, .

I just had a really good route and got into the zone!' WHERE `ID`=92443;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (92443,0,0,0,0,'I feel really bad, I''m so sorry.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Wooo! Smelting!' WHERE `ID`=92445;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (92445,0,0,0,0,'Smelting is so much fun!',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Ohhh... this Dust sparkles like a dream!

If you find more, bring it to me! I''ve treasures rare and wonderful to trade for in exchange!' WHERE `ID`=92448;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='See? It''s a long way down.' WHERE `ID`=92450;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (92450,0,0,0,0,'...',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Hey, ! I jumped off de waterfall and I killed a big lizard!

I know you helped.

Jynx helped too.

Thanks!' WHERE `ID`=92453;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Stay down, ! Don''t give away my hidin'' spot.' WHERE `ID`=92492;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (92492,0,0,0,0,'...',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Idago was taken into de crypt! They are sayin'' de big boss Mish''mosh has somethin'' nasty in store for him.' WHERE `ID`=92493;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='By Nalorakk''s maw, you put a dent in their forces.' WHERE `ID`=92495;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You''ve done a great honor for our tribe by defendin'' our lands against de Twilight''s Blade.

But Idago is not happy that I came back.' WHERE `ID`=92496;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='De girl''s foolishness aside, I owe you my life.' WHERE `ID`=92497;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I haven''t set foot on Argus in years. A dead world, populated by a broken people and their memories.' WHERE `ID`=92505;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Yes, that looks like enough. We''re nearly prepared, .' WHERE `ID`=92506;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I''ve only ever wanted to protect my people. Just like how demon hunters protect Azeroth.' WHERE `ID`=92507;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Yes, this captured void energy will do nicely.' WHERE `ID`=92508;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='There is no question now, . Demon hunters are the apex predators on this planet.' WHERE `ID`=92509;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I believe we have some equipment that can be repurposed to help Leona return to us.' WHERE `ID`=92510;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (92510,0,0,0,0,'What we''re doing is risky, . But that''s always been the way with the Illidari.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='So few. But the ones you saved are more than I had hoped for.' WHERE `ID`=92520;
UPDATE `world`.`quest_template` SET `QuestDescription`='Good news! We have a lead. Rexxar has agreed to help us find Scrapes. If anyone can track down that undead murderer, it''s him.

Rexxar has followed the scent to the Borean Tundra. He left this note for you.' WHERE `ID`=92523;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Good, you found me. Now the hunt can begin.' WHERE `ID`=92523;
UPDATE `world`.`quest_template` SET `QuestDescription`='Good news! We have a lead. Rexxar has agreed to help us find Scrapes. If anyone can track down that undead murderer, it''s him.

Rexxar has followed the scent to the Borean Tundra. He left this note for you.' WHERE `ID`=92524;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Good, you found me. Now the hunt can begin.' WHERE `ID`=92524;
UPDATE `world`.`quest_template` SET `QuestDescription`=':' WHERE `ID`=92546;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`=':' WHERE `ID`=92546;
UPDATE `world`.`quest_template` SET `QuestDescription`=':' WHERE `ID`=92549;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`=':' WHERE `ID`=92549;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Fascinating, it seems as though the magic of your new accessory is capable of awakening otherwise inaccessible powers of your artifact weapon, or even enhancing them beyond their limits!

I wonder if all jewelry has this same connection to your artifact weapon. Please do keep me informed of any more anomalies.' WHERE `ID`=92563;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Oh my, the crate you describe does indeed seem quite great. The joy of placing them will know no bounds.

Thank you for finding this! For your time, might I present you with this rare piece from our collection.

It is no ordinary barrel, to be sure! I hope that you enjoy it thoroughly.' WHERE `ID`=92572;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Your new magical light is quite astonishing! The accents of the finely-curved metal...

In terms of metal balls, I have seen few of its quality. I would place it on a desk or end table. I can see it now!

Though I will have no place to put my scrolls, I must provide something in return. Take my bookshelf, it has served me well.' WHERE `ID`=92577;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (92577,0,0,0,0,'You never really know a cabinet until you''ve checked the hinges.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Ah! You have located the sconces, then. I shall head over and purchase some myself at once, thank you!

Just as soon as you are not looking.' WHERE `ID`=92578;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (92578,0,0,0,0,'How do these lights stay lit? It is their nature.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Ah, the chair that you found, it is quite appropriate indeed.

For you, this coil.

I hope that you do not shock yourself! Sometimes we must sacrifice for art.' WHERE `ID`=92580;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (92580,0,0,0,0,'There is an old riddle, "when is a chair, not a chair?".

I do not know the answer.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You have found the requested Decor once more!

You are quite talented at this. I hope that you continue your adventure into the world of Decor, for there is no limit to it beyond your creativity.

You may take the table in front of me, for I have no more need of it. Perhaps we shall meet again!

Until then, farewell!' WHERE `ID`=92581;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (92581,0,0,0,0,'A rug is meant to be walked on, and accepts this fate.

There is much to learn from Decor.',0);
UPDATE `world`.`quest_template` SET `QuestDescription`=':' WHERE `ID`=92582;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`=':' WHERE `ID`=92582;
UPDATE `world`.`quest_template` SET `QuestDescription`=':' WHERE `ID`=92583;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`=':' WHERE `ID`=92583;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Tales of your own accomplishments mingle into the chorus of echoes emanating from the now repaired stone.' WHERE `ID`=92600;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Remarkable. This chisel is not made to carve stone or metal, but the Void itself. It can free me from this shade.' WHERE `ID`=92606;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Oh my, these photos are just exquisite!' WHERE `ID`=92608;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (92608,0,0,0,0,'This place is such a delight, so laid back and rustic.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Allari seeks to test my resolve. Nothing will deter me from this pursuit.' WHERE `ID`=92630;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='These parts are pristine. Well done, both of you.' WHERE `ID`=92631;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (92631,0,0,0,0,'A demon hunter wields their ire, but is never ruled by it.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Did Aedh Firebeard send you? Well then welcome, , to our Midsummer celebrations!

Care to hear our tale?' WHERE `ID`=92635;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Another prosperous arrangement. You have my thanks.' WHERE `ID`=92647;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (92647,0,0,0,0,'Are we in business?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='...' WHERE `ID`=92671;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (92671,0,0,0,0,'...',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='...' WHERE `ID`=92673;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (92673,0,0,0,0,'...',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='...' WHERE `ID`=92675;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (92675,0,0,0,0,'...',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='...' WHERE `ID`=92676;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (92676,0,0,0,0,'...',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='...' WHERE `ID`=92677;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (92677,0,0,0,0,'...',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You have fought by our side through our darkest hour and during our greatest triumphs. It is only fitting you join us on this day.' WHERE `ID`=92689;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='A dog? Yes I''ve seen a dog--look at this place! Just look at what he''s done!' WHERE `ID`=92729;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Some of the lines look a little crooked.' WHERE `ID`=92740;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (92740,0,0,0,0,'Here''s your extremely genuine Brawler''s Guild Invitation.

Please note all sales are final.

There will be no refunds, or receipts.',0);
UPDATE `world`.`quest_template` SET `QuestDescription`=':' WHERE `ID`=92746;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`=':' WHERE `ID`=92746;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The citizens of Silvermoon were quite enthused by your aerial display over the city.

Even the dragonhawks seemed to enjoy the glow of the blossoms overhead.

Thank you for bringing joy to so many during this summer festival.

The spirits of fire and An''she himself will be pleased.' WHERE `ID`=92821;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (92821,0,0,0,0,'May An''she bless your path.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='With Rezan defeated, King Rastakhan was in big trouble. He was wounded far deeper than any physical strike, as his connection to health and longevity were both ripped away.' WHERE `ID`=92826;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (92826,0,0,0,0,'The loa have almost always been connected to the trolls. The Zandalari were the first!',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The Drakkari empire crumbled after Gundrak fell. It couldn''t recover from the turn into darkness and the aftermath that followed.' WHERE `ID`=92829;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (92829,0,0,0,0,'The Drakkari tried to kill all of their loa.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Hakkar hoards power to himself, refusing to work with anyone else. He''s powerful, but isolated.' WHERE `ID`=92831;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (92831,0,0,0,0,'Hakkar''s caused several lifetimes worth of problems for Azeroth.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Both loa and troll have tried to force the bond of the hash ''ey, but the strongest bonds are when they work together.

There''s so much to learn about the loa. I''m still collecting their stories, but this was a good start!' WHERE `ID`=92832;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Some of the lines look a little crooked.' WHERE `ID`=92851;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (92851,0,0,0,0,'Here''s your extremely genuine Brawler''s Guild Invitation.

Please note all sales are final.

There will be no refunds, or receipts.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='What, you think I''m just going to give you my crafts for free?

I suppose that''s exactly what I''m going to do. Eternus''s orders, something about speeding up the experiment.

Just don''t lose it or, worse, let Erus anywhere near it.' WHERE `ID`=92855;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='It pains me to cull the drifter population. However, if left unchecked, their numbers would have led to the collapse of the ecosystem.' WHERE `ID`=92864;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The budlings seem to be satiated for now. I am comfortable moving to the second phase of reintroducing them to their natural habitat.' WHERE `ID`=92865;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I will give you my blessing, . Although you are not a Ka''dani, tales of your prowess precede you. Your skills in the hunt need no introduction.

I know that you will be able to give Ketan the guidance he needs.

You will both take part in the Ka''dani trials: you as an honorary Ka''dani, and Ketan as your trainee.' WHERE `ID`=92882;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='These look pristine.

Thank you for doing this for me. Maybe one day I will be able to do the same for someone else.' WHERE `ID`=92883;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I see now that your presence here and Ketan''s perseverance were set by the goddess herself. I am impressed by your actions and resolve. Thanks to you, Ketan''s path is clear.' WHERE `ID`=92885;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Amani history, painted on the walls of our ancestors. This magic does not work without a bond between our peoples.' WHERE `ID`=92901;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Why is my uncle so disorganized?' WHERE `ID`=92904;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Did you hear what it said? A weapon!' WHERE `ID`=92907;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (92907,0,0,0,0,'What does dis mask know?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I see your interest has been piqued.

Excellent.' WHERE `ID`=92926;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Their sacrifice was for de good of the Amani, whether dey knew it or not.' WHERE `ID`=92934;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='De armies of de aqir are without end. Dey are all around us.

We fought hard, Nek''zali. But we are out of options.' WHERE `ID`=92935;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (92935,0,0,0,0,'De promise of an empire was a lie. De Zandalari sent us to our deaths.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Did you hear that? This world was called Predacea!

What a revelation!' WHERE `ID`=92944;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='One fool''s trap is another elf''s treasure.' WHERE `ID`=92945;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (92951,0,0,0,0,'Dis search for Ula''tek is becomin'' more dangerous than Zul''jan realizes.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Malacrass is dead, but dat doesn''t mean his knowledge is lost.' WHERE `ID`=92952;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The Maisara Caverns are even more dangerous than de Deeps, and Vordaza is as deadly as she is cruel.' WHERE `ID`=92953;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (92953,0,0,0,0,'What did you find out?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You got dem. Now let''s see if dis was worth all de effort.' WHERE `ID`=92954;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (92954,0,0,0,0,'Will Malacrass''s notes hold de next clue? Or is dis all just a waste of time?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Uncle does not understand. Ula''tek could change everything.' WHERE `ID`=92955;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Look here! Dis mentions the Amani summoning a great serpent to save dem from a terrible foe.

And here, de serpent was victorious but de Amani sealed it away.

De first shrine built in Atal''Aman was dedicated to the serpent.' WHERE `ID`=92957;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (92957,0,0,0,0,'Let me take a look at the rubbings...',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='It will just take a moment to drain de magic from de fetishes.' WHERE `ID`=92958;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (92958,0,0,0,0,'De magic of the Vilebranch feels so familiar... Did dey put me in this mask?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Dis shrine is ancient. Small. Unremarkable.

De perfect hiding place.' WHERE `ID`=93010;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I have already sent scouts to search for Zul''jan, but it will be impossible to cover so much ground. I pray he sees through de lies dat Malacrass has woven before it''s too late.

Thank you, , for telling me what happened and for being with my uncle at de end.

Dis eagle was my uncle''s favorite companion on his walks through Zul''Aman. I think he would like it if you took care of him now dat he''s gone.' WHERE `ID`=93012;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93012,0,0,0,0,'How could this have happened?',0);
UPDATE `world`.`quest_template` SET `QuestDescription`=':' WHERE `ID`=93013;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`=':' WHERE `ID`=93013;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='My brother has much to answer for. His path is growin'' darker with each step he takes.

Whether he knew about their capture and torture, or was just lettin'' it happen, it is clear I need to knock some sense into him.' WHERE `ID`=93018;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93018,0,0,0,0,'I will fight for dem until dey are free.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Praise dat Jan''alai found us worthy of our blessin''.

Praise dat de hash''ey''s will has been done!' WHERE `ID`=93022;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93022,0,0,0,0,'Did you fry de eggs and de hens dat laid dem?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='That dagger... that power...

What is he doin''?

We have to talk him down.' WHERE `ID`=93023;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93023,0,0,0,0,'Dey must be dealt with, $m.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I can assure you that it will seldom be this easy.' WHERE `ID`=93043;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You are an impressive hunter, dat is for sure. Thank you for helpin'' us out here.' WHERE `ID`=93047;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Dat boy still needs a lot of practice, but you helped him get out of his head and just feel de rhythm.' WHERE `ID`=93048;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='All in perfect condition!

Maybe you should be de apprentice instead.' WHERE `ID`=93049;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='My days of combat are behind me, but I''m glad to be helpin'' out around de village.' WHERE `ID`=93050;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You fought well.

Your own strength proved Dar''rak can hold his own against warriors far stronger than himself.

I never expected him to beat you, . But de fact that he still breathes is an impressive enough feat, hm?' WHERE `ID`=93051;
UPDATE `world`.`quest_template` SET `QuestDescription`=':' WHERE `ID`=93053;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`=':' WHERE `ID`=93053;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Hopefully this diversion has been enlightening.' WHERE `ID`=93055;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Yes, now you are prepared.' WHERE `ID`=93056;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93056,0,0,0,0,'With knowledge comes power. In this case, with power comes knowledge. Do you feel sufficiently powerful yet?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='<Time to find your perfect home!>' WHERE `ID`=93057;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Let us begin.' WHERE `ID`=93086;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Dis is plenty!

All of dem were actually dead... right?' WHERE `ID`=93094;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Hah! Tusk Taker is dead!

De others will see me as a true Amani warrior now--when I tell them I took all de trophies that killed Tusk Taker.' WHERE `ID`=93095;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Excellent progress. Here are the spoils of your victory.' WHERE `ID`=93112;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Excellent progress. Here are the spoils of your victory.' WHERE `ID`=93113;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Excellent progress. Here are the spoils of your victory.' WHERE `ID`=93114;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Excellent progress. Here are the spoils of your victory.' WHERE `ID`=93116;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Excellent progress. Here are the spoils of your victory.' WHERE `ID`=93117;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Excellent progress. Here are the spoils of your victory.' WHERE `ID`=93118;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Excellent progress. Here are the spoils of your victory.' WHERE `ID`=93120;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Take these heraldries straight over to the Crafting Order station to get a custom piece. Anything you make with these will keep you safe while crossing swords in the battlegrounds. If you ever want more heraldries I''ve got what you need.

For a price this time, of course.' WHERE `ID`=93171;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='What was she doin'' out past de log bridge? I told her not to go there.

And with my basket and our best tea kettle?

Oh... oh, no. She wouldn''t! And alone?' WHERE `ID`=93178;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I had to see her.

Just one more time.' WHERE `ID`=93181;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You''re back! Did you find her?

Is dat her comin'' now?' WHERE `ID`=93182;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I''m gonna crush that mask.' WHERE `ID`=93265;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='So de murloc chieftain had a shadow-filled crystal? I wonder...

It is possible dat de murlocs unearthed dis ancient relic and dat its power consumed dem. A pity it was destroyed. I would have liked to study it.

Ndamu is a great loss, but de work you did here today means her sacrifice was not in vain. De snakes have been dealt a solid blow, de murlocs should start calming down, and we destroyed de source of de dark energy. Thank you, .' WHERE `ID`=93340;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93340,0,0,0,0,'Your time was not wasted in gathering de trinkets. We were able to narrow down de source once we ruled them out!

That aside, I have never felt anything like de ripples of darkness coming from dat tower. Find and destroy whatever it is dat''s controlling de murlocs.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='At this point, it''s a game.

I know he''s there. He knows I know he''s there, but if I keep pretendin'' I don''t see him, I win dis round!

I wouldn''t hate it if you helped him, though. Then we both win. Don''t you tell him I said it.' WHERE `ID`=93387;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93387,0,0,0,0,'What do you mean you don''t see a ghost?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You''re a useful creature!

I have ghosts dat harass me and murlocs makin'' a mess every time I leave my hut. If de pests were not pesterin'', dey wouldn''t be pests, would dey?

I can tell--you''re gonna be de one to solve my problem.' WHERE `ID`=93388;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93388,0,0,0,0,'Did you bring de goods?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='These pieces are comin'' together... I almost have it. Get back to Ofi. I need to ponder dis for a bit.

I feel hope again,  You did dis, and I give you my gratitude.' WHERE `ID`=93389;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93389,0,0,0,0,'...',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Oosha! Dat is potent. I did not know your strength.

At least there was no explosion dis time.

Not bad,' WHERE `ID`=93390;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93390,0,0,0,0,'You feelin'' challenged?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Ha! Well done. Dat should keep dem runnin'' for a while.

I do love de smell of chaos in de morning.

Of course, it could also be you. Could you stand back a ways?' WHERE `ID`=93391;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93391,0,0,0,0,'Have de murlocs moved on?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I may weep from de joy dat has filled my spirit. I thought she was gone so long ago dat even she eventually moved on from my mind.

Now my sweet Sava will be with me forever.

Thank you, .' WHERE `ID`=93392;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93392,0,0,0,0,'Did you find it?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I''ve been focusing on my own feelings so much that I never stopped to think about how Veraan might feel.

I may not have fared any better had they pumped ME full of Void.' WHERE `ID`=93396;
UPDATE `world`.`quest_template` SET `QuestDescription`=':' WHERE `ID`=93397;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`=':' WHERE `ID`=93397;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='... thank you. I saw so much.

It''s too late... No!

We must find my brother.' WHERE `ID`=93419;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I am... glad that the Amani were able to deal with this "Ula''tek" on their own with your and Liadrin''s help.

Hopefully, we hear less of them in the future.' WHERE `ID`=93420;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='See? An endless ocean.

Perhaps Doru will learn something from de ashes.' WHERE `ID`=93432;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Barriers holdin''? Good.

Now we can focus on de offensive.' WHERE `ID`=93433;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I admit it, : knowin'' you have slain de instigators brings warmth to my old bones.

Does dat lower your opinion of me?' WHERE `ID`=93435;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='De echoes are running from de battlefield like scared hogs because of ya work!' WHERE `ID`=93436;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Thank you, hash''ura. Truly.

The battle against de echoes will continue. However, it would seem they cannot return after being slain now that their leader has been dealt with.

Memories stirred my blood these last few days. Now we can all rest. Perhaps even move on?

Bah! It''s just de ravin'' of an old warrior. Do not mind me.

Simply consider myself in your debt.' WHERE `ID`=93437;
UPDATE `world`.`quest_template` SET `QuestDescription`=':' WHERE `ID`=93438;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`=':' WHERE `ID`=93438;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='...' WHERE `ID`=93452;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Excellent. Feel free to make new arrangements whenever you would like.

I, like death, am a patient man.' WHERE `ID`=93453;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93453,0,0,0,0,'Have you made your selection?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`=', you''ve returned.

What tales do you bring?' WHERE `ID`=93495;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93495,0,0,0,0,'Your return is foreseen, at a later time.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='It''s not every day one bears witness to the Dragon Aspects reforming. Cherish these moments.' WHERE `ID`=93497;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93497,0,0,0,0,'Quickly now. Time waits not.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Very impressive - you''ve earned these.' WHERE `ID`=93499;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Good. Now as long as nothing goes wrong we can get to the good part.' WHERE `ID`=93501;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93501,0,0,0,0,'Ready to get going?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Great work, soldier. Take these.' WHERE `ID`=93502;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93502,0,0,0,0,'You still have more to show what you''re capable of.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Great work! You have earned these.' WHERE `ID`=93503;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93503,0,0,0,0,'Finish off what you set to do then come back.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Great practice! You''ve earned this!' WHERE `ID`=93504;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93504,0,0,0,0,'Repetition is key.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Great effort.. Here, take this.' WHERE `ID`=93505;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93505,0,0,0,0,'Give it an honest try - finish up.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='It pays off to have an open mind! Take this for your time.' WHERE `ID`=93506;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93506,0,0,0,0,'There''s still more to explore.',0);
UPDATE `world`.`quest_template` SET `QuestDescription`=':' WHERE `ID`=93507;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`=':' WHERE `ID`=93507;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Kidnapping a murloc? For shame.' WHERE `ID`=93511;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93511,0,0,0,0,'He looks devastated.',0);
UPDATE `world`.`quest_template` SET `QuestDescription`=':' WHERE `ID`=93517;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`=':' WHERE `ID`=93517;
UPDATE `world`.`quest_template` SET `QuestDescription`=':' WHERE `ID`=93524;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`=':' WHERE `ID`=93524;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Thanks for the assist.

I''ve been where Finley was.' WHERE `ID`=93525;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93525,0,0,0,0,'He''ll get what''s coming to him.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Take this, hash''ura.

Continue provin'' your strength, and we''ll continue to show you our honor.' WHERE `ID`=93566;
UPDATE `world`.`quest_template` SET `QuestDescription`=':' WHERE `ID`=93571;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`=':' WHERE `ID`=93571;
UPDATE `world`.`quest_template` SET `QuestDescription`=':' WHERE `ID`=93573;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`=':' WHERE `ID`=93573;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Dat be a dark business indeed. So many lost, to such a terrible fate!

But no more, thanks to you. You have de Witherbark''s gratitude... and mine.' WHERE `ID`=93575;
UPDATE `world`.`quest_template` SET `QuestDescription`=':' WHERE `ID`=93577;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`=':' WHERE `ID`=93577;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`=';Lestia Goldenstrike
Ye look like someone who could learn the art of bein'' a lumberjack!

I can teach ye real quick how to identify which trees are prime for gettin'' some lumber.

Lumber has all sorts of uses when crafting stuff for yer house. Or other folks'' houses, if you care to sell your goods. Might want to visit some o'' your old craftin'' teachers to brush up while you''re at it. They''ve got some new things to teach, I''d wager!

So get what ye can and see what ye can make of it!

;Xiz''ro
Ya lookin'' like you be someone who can pick up how ta be a lumberjack.

I can show ya how to find de trees that are best to be cuttin'' for lumber.

Lumber be useful for crafting lotsa tings for ya house. Or even for other houses, if you wanna gift or sell anyting. I bet those old craftin'' trainers you already learned from be havin'' some new things to teach ya, too.

Get out dere and see what ya can do!' WHERE `ID`=93647;
UPDATE `world`.`quest_template` SET `QuestDescription`=':' WHERE `ID`=93648;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`=':' WHERE `ID`=93648;
UPDATE `world`.`quest_template` SET `QuestDescription`=':' WHERE `ID`=93649;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`=':' WHERE `ID`=93649;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='So it is done, then.

Ruia''s demise is a tragedy. You never knew him as such, but he was once a man of honor and conviction. To think that the light would blind him so completely to the folly of his ambitions...

In the end, he thought he was doing what was best for Harandar. I can only hope his soul finds both peace and forgiveness, as it seeks Aln''hara in death.' WHERE `ID`=93651;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93651,0,0,0,0,'Ruia is too powerful to challenge alone. Who knows what manner of overgrown monsters lurk in the heart of the Lightbloom?',0);
UPDATE `world`.`quest_template` SET `QuestDescription`=':' WHERE `ID`=93664;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`=':' WHERE `ID`=93664;
UPDATE `world`.`quest_template` SET `QuestDescription`=':' WHERE `ID`=93669;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`=':' WHERE `ID`=93669;
UPDATE `world`.`quest_template` SET `QuestDescription`=':' WHERE `ID`=93670;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`=':' WHERE `ID`=93670;
UPDATE `world`.`quest_template` SET `QuestDescription`=':' WHERE `ID`=93671;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`=':' WHERE `ID`=93671;
UPDATE `world`.`quest_template` SET `QuestDescription`=':' WHERE `ID`=93672;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`=':' WHERE `ID`=93672;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='A sight to behold, is it not?

Since the time of Dath''Remar, the elves have used this great forge to craft armor of unparalleled might. It is said that the flames were first stoked by the soul of a phoenix who thought it a fitting nest, and that its power still weaves itself through every creation.

We will permit you to share in its gifts.' WHERE `ID`=93687;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='This dust is of exceptional quality! Come, I will show you some techniques that make use of it.' WHERE `ID`=93697;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93697,0,0,0,0,'Have you collected the dust?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='This will make many fine and powerful enchantments.' WHERE `ID`=93699;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93699,0,0,0,0,'Have you succeeded?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Sometimes a simple blend is the best blend. No shame in sticking to the basics.' WHERE `ID`=93704;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93704,0,0,0,0,'We''ll take whatever you can offer.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Excellent! This will make a fine assortment of weapons.

I''m sure we''ll get another order soon enough, so keep some spare tin around.' WHERE `ID`=93706;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93706,0,0,0,0,'Anything you can contribute will be appreciated.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Ah, yes. This quantity should be sufficient. I''ll have it packaged up for the engineers.' WHERE `ID`=93708;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93708,0,0,0,0,'Tin and silver are both remarkably conductive. I could elaborate, if you have a few hours?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You are one of the most reliable miners I''ve ever had the pleasure of meeting.

Thank you. Truly.' WHERE `ID`=93709;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93709,0,0,0,0,'I suppose I could bring on a few more apprentices, if I have to...',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Well, this should be enough to cover the most recent order. I''ll try to restock in preparation for the next one.

Pleasure working with you.' WHERE `ID`=93713;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93713,0,0,0,0,'I''ll never understand orcish fashion.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You took to that like a cloak to concealment. Well done!

But, in this game, a good disguise or hiding spot isn''t always enough. There is much more for you to learn.' WHERE `ID`=93716;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93716,0,0,0,0,'Touch this armchair, to don its disguise...',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Nicely done! But that''s only half the game, isn''t it.

Next, let''s get you exposed to some Capturing tactics. If you think you can handle it, of course.' WHERE `ID`=93717;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93717,0,0,0,0,'Use the disguise chair to swap with other decor, then return to me.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Not bad for a first time. You''re taking to this quite naturally!' WHERE `ID`=93719;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93719,0,0,0,0,'Use my statue, then find and tag hiders with the Spellbreaker''s Dispel Magic and Tag.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Fulfilling these work orders is imperative to the war effort. Your services are greatly appreciated.' WHERE `ID`=93723;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93723,0,0,0,0,'Have you talked to Mar''nah?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You didn''t need to burn my things...' WHERE `ID`=93734;
UPDATE `world`.`quest_template` SET `QuestDescription`='thumb|Unity Against the Void choice UI
Unity against the Void.

;Abundance

;Arcantina

;Battlegrounds

;Delves

;Dungeons

;Housing

;Legends of the Haranir

;Offworld Showdowns

;Prey

;Raid

;Ritual Sites

;Saltheril''s Soireee

;Stormarion Assault

;Vaults of Atal''Utek

;Void Assaults

;World Boss

;World Quests' WHERE `ID`=93744;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='So you survived your meeting with the elders. I am surprised, but also pleased.

You aided the children of Har''athir without hesitation. For that, I welcome you and offer you the hospitality of Amirdrassil''s roots.' WHERE `ID`=93745;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Well done. Together, our light will outshine the darkness the Void brings.' WHERE `ID`=93766;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Ah, you''ve returned. I am glad you allowed yourself that well-earned moment of peace.' WHERE `ID`=93767;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93767,0,0,0,0,'We all need a moment away from the battle now and again.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You''ve given your heart. That is what truly unites us.' WHERE `ID`=93769;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I have heard of your travels, outsider. I am Kamari, Rootwarden of Nordrassil.

The mists of Har''kuai hold many mysteries. I hope you will find them enlightening, during your stay here.' WHERE `ID`=93771;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Greetings! Are you here to learn more about our joint venture?' WHERE `ID`=93774;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Ah! . Welcome back. As you can see, our hands are full as ever, here.

I assure you, I have things well in hand. But if you do wish to explore a bit further afield, I am sure some of the others could benefit from your assistance.' WHERE `ID`=93775;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Thank the goddess you returned.

As you can see, we''re still in fairly dire straits here. Though we quelled its spread beneath Shaladrassil''s roots, the Lightbloom remains a threat. There are rumors of fungarians acting erratically in Fungara Village. And there is no Rootwarden in Har''alnor to deal with either.

Thankfully, we have the next best thing: an intrepid outsider with a habit of helping others.' WHERE `ID`=93776;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='An extraordinary find. The arcane energies emanating from your discovery clearly predate the Shattering... We could learn much from such artifacts.

Champion! Fantastic work! If you happen upon any more during your expeditions, please bring your findings back to me.' WHERE `ID`=93784;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Ya spirit is flowing with strength!

You may use de altar as often as ya wish. But ya can only hold one blessing on ya self at a time.' WHERE `ID`=93792;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93792,0,0,0,0,'De loa are quite generous indeed.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Dis is for you. It isn''t much, but it''s all we can spare.

Keep fighting. De Amani depend on it.' WHERE `ID`=93798;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The Sunwell stands another day because of you. Go with the blessings of the Sin''dorei.' WHERE `ID`=93811;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Splendid! Well done out there, !

You did well! And there are even more abilities and other Kits for you to discover and learn.' WHERE `ID`=93816;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93816,0,0,0,0,'? No, I do not see your name on any of the game rosters.

Speak with Gamemaster Fleurian to join a game of Decor Duel.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I see. Been too long since I last gave her flowers. Her memory of dem, and of our time together, may be long gone.' WHERE `ID`=93849;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93849,0,0,0,0,'I remember de first time I gave her flowers. I didn''t think a warrior like her could blush, but she did. I hope I never forget her smile dat day.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Challenge Eshaye? Of course! Why didn''t I think of dat?

Erm, probably because I can''t beat her.' WHERE `ID`=93851;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93851,0,0,0,0,'I hope one of dem has some ideas. I am running out of time.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Good. But one victory proves nothing. The path to supremacy requires sustained practice.

Return tomorrow and demonstrate your skills further.' WHERE `ID`=93865;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Ah, well done! I watched you out there, and it was quite thrilling!' WHERE `ID`=93870;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93870,0,0,0,0,'Your task remains incomplete, .',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You''ve done well to navigate the Court without being swallowed by its politics. Silvermoon needs those who can act with purpose, not those lost in the machinery of ambition.' WHERE `ID`=93889;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You have met the Loa of Abundance. May its gifts serve you well.' WHERE `ID`=93890;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93890,0,0,0,0,'Respect the loa, but beware of their power.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You have seen what the Zur''ashar preserved. Through their living art, the past speaks still.' WHERE `ID`=93891;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The Citadel stands as proof of what we can achieve together.

Against unity, even the Void itself must yield.' WHERE `ID`=93892;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`=':' WHERE `ID`=93905;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Excellent! Great work, . Don''t forget to check in often! You''ll want to make sure you unlock the full potential of all the Kits available in order to maximize your enjoyment--and points-earning potential, of course.' WHERE `ID`=93907;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93907,0,0,0,0,'Those coins were a one-time gift, . If you have mislaid them, or have suffered the misfortune of thievery, then I suppose you will have to enter the games to collect more.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You''ve braved the delves and returned stronger for it.

Valeera was right--opportunity favors the bold.' WHERE `ID`=93909;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93909,0,0,0,0,'Stay sharp, .',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Astalor serves Silvermoon''s cause, though his path to that end is rarely a straight one.' WHERE `ID`=93910;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93910,0,0,0,0,'Astalor''s mind is sharp, though his ambitions run deep. Keep both eyes open, .',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You''ve proven your mettle once more.

May your victories within strengthen you for what lies ahead.' WHERE `ID`=93911;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93911,0,0,0,0,'Be ready for anything. Fortune often walks hand in hand with peril.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You''ve faced the darkness and emerged stronger.

Well done, .' WHERE `ID`=93912;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93912,0,0,0,0,'Hold fast, champion.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='May your victories light the path for all who follow.' WHERE `ID`=93913;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (93913,0,0,0,0,'Do not waver, .',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I half expected you to run back home in tears! I hope you had a stunning time.' WHERE `ID`=93930;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Heh! So ya finally met Dundun.

Even de smallest are some of de greatest among de loa!' WHERE `ID`=93931;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I wonder what it is that the stones showed you. I hope you found it enlightening, . But remember: there is always more to learn.' WHERE `ID`=93932;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Well done, .' WHERE `ID`=93933;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Did you hear that? It most certainly did something!

Huzzah!' WHERE `ID`=93970;
