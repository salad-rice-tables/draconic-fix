-- Fill empty QuestCompletionLog (119) + progress CompletionText (28) from Wiki verbatim.
-- Audit: docs/wiki_batch_{A,B,C,D}.json + wiki_text_diff.json (2026-10-13).
-- Markup resolved: [[A|B]]->B, [[A]]->A, <name>->$n. Additive only (DB fields were empty).
-- Undo: 20261013_wiki_textfill_undo.sql
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The Light has called you, $n. Our hope rests in the champions of Azeroth and the Vanguard of the Light!' WHERE `ID`=88719;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='We must use this miraculous event to turn the tide against chaos. We must not falter.' WHERE `ID`=86769;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86770,0,0,0,0,'You have gathered help?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The citizens have boarded the ships. They will soon reach the safety of Silvermoon.' WHERE `ID`=86805;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86805,0,0,0,0,'The ships still have space for more! Rescue as many as you can.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Thank you, <Name>. These rescue missions are rarely as straightforward as they seem. There is always one more threat that appears that you didn''t account for.' WHERE `ID`=89012;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The ships have crossed the strait and the refugees have made it safely to Silvermoon. Thank you, $n. You have done my people a great service.' WHERE `ID`=86806;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Champion, I am glad to hear so many of the sin''dorei survived. Even though this was contrary to my orders to the Vanguard, you are not under my command. You acquitted yourself well. Arator did not.' WHERE `ID`=86807;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='With those Void pylons destroyed, the Devouring Host has weakened. We may have a chance of winning this.' WHERE `ID`=91274;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (91274,0,0,0,0,'We need to activate all the sentinels if we want to destroy the Void pylons.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Going behind our lines was reckless! Was this Arator''s idea? He has been so headstrong lately.

Sorry, $n. I shouldn''t air this family business. I will admit that your actions have aided the Vanguard of Light in this battle.' WHERE `ID`=86834;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Excellent work, $n. I knew I could count on you.' WHERE `ID`=86811;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Were they just here to loot us? Or did they have some reason to seek out weapons of the Light?

I''ll save that speculation for later. The Vanguard can use these weapons now. With them, we will push this Devouring Host off Quel''Danas!' WHERE `ID`=86848;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='By the Light! We cannot win this battle. Our only hope lies in the Sunwell!' WHERE `ID`=86849;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='May the Light bless and protect you, $n. Your defense of the Sunwell chamber made this miracle possible.

We have not beaten Xal''atath, but we have forestalled the invasion of her Devouring Host. We now have the time to catch our breath and discover what we must do to defeat her.' WHERE `ID`=86852;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86735,0,0,0,0,'Have you spoken to everyone yet?',0);
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86737,0,0,0,0,'How am I supposed to handle all of this myself?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='<Umbric looks stricken.>

That is not the news I was expecting. No!' WHERE `ID`=86621;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I don''t understand. What was she doing with all this information?' WHERE `ID`=86623;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='There''s far more to Tranquillien than meets the eye, it seems.' WHERE `ID`=86624;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='It is heartening that you trust me with these serious concerns.' WHERE `ID`=90907;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The Twilight''s Blade--Antenorian, what have you done!' WHERE `ID`=86626;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86632,0,0,0,0,'Let''s hope there''s enough left here to rebuild.',0);
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (90493,0,0,0,0,'Tranquilien will not fall under my watch!',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='It seems all is well here... for now.' WHERE `ID`=86781;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The Twilight''s Blade were already skulking around the perimeter... We were right to come here quickly.' WHERE `ID`=86634;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='No! No... I was so close.

<Umbric collects himself--a paradigm of focus.>

Deatholme it is, then. The base of the Twilight''s Blade.' WHERE `ID`=86633;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I am loath to find myself here again... but it is the only way.' WHERE `ID`=86635;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86638,0,0,0,0,'Fairbreeze was nothing compared to this. What... happened here?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The Twilight''s Blade are terrorizing Zul''Aman as well? This is no coincidence!' WHERE `ID`=86643;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You made that look easy.' WHERE `ID`=86644;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='There he is--the one who leads this little incursion.' WHERE `ID`=86648;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86648,0,0,0,0,'We will drive these trolls out of our land once and for all.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Would that I could join you, but there is much still to do here in Silvermoon.

You have your objectives. Keep in touch.

As for Arator... I hope you find him soon. Anu belore dela''na, <Name>.' WHERE `ID`=86650;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I find myself relieved to discover Zul''jan is not the leader of the Amani.

But this "Zul''jarra" might be worse.

No matter. We must get on the other side of that gate and assess the Twilight''s Blade''s threat to Eversong.' WHERE `ID`=86710;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86868,0,0,0,0,'Zul''jarra seems quite pragmatic in comparison to her brother.',0);
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86718,0,0,0,0,'Have you ended him yet?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='<Zul''jarra seethes with rage.>

Mor''duun is playin'' with us. He coulda stayed and destroyed de city outright.

If chaos is de Twilight''s Blade''s plan, we need to prepare.' WHERE `ID`=86720;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86720,0,0,0,0,'...',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='There is... much you do not know about us and de loa.' WHERE `ID`=86723;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86653,0,0,0,0,'...',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='That voice...

You heard it too, <Name>?' WHERE `ID`=86656;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86656,0,0,0,0,'...',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='<Zul''jarra''s eyes are closed. She seems lost in thought.>

Dey were here all along. It was my grandfather''s fault dey would not answer.

<She nods her head and sighs.>

My grandfather broke dis. It is up to me to fix it. It is de only way to save my people.' WHERE `ID`=86809;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86658,0,0,0,0,'Finding Halazzi can wait. The Vilebranch are preyin'' on my people. It''s about time some predators hunted dem.',0);
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86660,0,0,0,0,'Keep on de lookout for more Witherbark captives!',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Like Akil''zon, Halazzi was watching. Waiting.

He never gave up on de Witherbark.' WHERE `ID`=92084;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='"Eccentric loa speaker."

Heh. That sounds familiar. I guess dey are all like dat.' WHERE `ID`=86661;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='<Zul''jarra watches the flames dance in the coals. A small smile creeps up on her face. She balls her fists and flexes her arms.>

I think dis trial is starting now.

Whatever it throws at me... I''ll be ready!' WHERE `ID`=86663;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='<Zul''jarra brushes some ash off her shoulder.>

Jan''alai''s flame... it has taken de doubts from my heart and given dem form.

I... was not prepared for dat.

What else do they have in store?' WHERE `ID`=86664;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86664,0,0,0,0,'No stoppin'' de trial now. We must do what needs to be done.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Fittin'' that de last test be facin'' my own doubt. About my leadership and my choices.

It felt good. As if de doubt melted away.

And I gotta say... I never seen flames so fit and handsome.

<Zul''jarra, despite it all, laughs heartily and claps you on the shoulder.>' WHERE `ID`=86665;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='We did it, hash''ura.

Jan''alai is reborn! And we have her blessin''.

<Zul''jarra closes her eyes and briefly enjoys the feeling of the flame against her face.>' WHERE `ID`=90772;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I love my brother. We are as de day is to de night. But even so, as children we were close.

Zul''jan is smart but he doesn''t understand. A victory means nothin'' if there is no one left to celebrate it.

He is supposed to be my right hand, not a pain in de neck.

I hope I have not left Zul''jan without guidance too long to turn him around.' WHERE `ID`=86681;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I do not pity Lilaju--I was around her age when I took my place as leader of de Amani.

I am proud of her. She is stickin'' up for herself and her tribe.

She gave us what we needed. And I will not go back on my promise of helping her.' WHERE `ID`=86682;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Heh.

We won against Nalorakk. We passed de last trial.

My tribe will sing songs and tell stories of dis day for generations.' WHERE `ID`=91958;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='That was good.

But I still thirst for more.' WHERE `ID`=86685;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I look forward to Lor''themar''s expression when I report back.

<A slight smile creeps across Liadrin''s blood-spotted jaw.>

It''s bound to be worth more than my inevitable reprimanding.' WHERE `ID`=86686;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The sight of de loa fightin'' by their side has filled our warriors with hope.

Dey remember dat dey are Amani!' WHERE `ID`=86687;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Mor''duun may laugh now, holed up in de Sanctum.

But we will get de last laugh.' WHERE `ID`=91001;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='<Zul''jarra snorts and spits out a viscous wad of blood, broken tooth included.>

It is done.' WHERE `ID`=86692;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='It did not occur to me dat what we would be celebratin'' would be... me.

There has been no hash''ey among de Amani since before de elf and human war thousands of years ago.

It is a great honor, but one I am not sure I have yet earned.

I will strive to live up to it.' WHERE `ID`=86693;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Glad I found you. Zul''jarra let me know you would be searching this area for Zul''jan, but this land is still so unfamiliar to me.

If you have found him and are finished enjoying the party, we should return to Silvermoon.' WHERE `ID`=91062;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='It is good to see you again, friend.

Would that we were meeting under less fraught circumstances.' WHERE `ID`=89402;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You made it. For a moment I wasn''t sure you would. Don''t worry--that nauseous feeling will pass.

We stand in the deep roots of Amirdrassil. My home lies beyond.

Let us see what welcome awaits.' WHERE `ID`=86899;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Welcome to the Den of Echoes. Within the caves beyond, you will find ancient paintings which tell the story of the haranir.

Perhaps you will learn something, if you survive. May Aln''hara be on your side.' WHERE `ID`=86907;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Koozat is the least of our troubles right now. The lightbloom has arrived. Har''mara is under attack!' WHERE `ID`=86910;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Welcome to Har''mara. I am glad to see you well and whole after the trials.

This village is the home of Hagar and many others who call Harandar their home.' WHERE `ID`=86913;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Sometimes harmony and friendship are helped by small acts of service.

I hope that the rutaani and fungarians here have come to see you as an ally.' WHERE `ID`=86914;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='To stay among us, it must be proven that the goddess has indeed called you to her aid.

You will undergo trials at the Den of Echoes, a holy place for our people.' WHERE `ID`=86929;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86929,0,0,0,0,'Orweyna will be judged for her actions.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Well done, $n. May Har''mara return to the peaceful oasis it was when we arrived.' WHERE `ID`=89034;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Tough, but needed work. May this slow the spread until we can find a way to stop it entirely.' WHERE `ID`=86973;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='It is done, then. I grieve that this was necessary, but the corruption needed to be pruned before it could spread further.' WHERE `ID`=86942;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Eonka and her seeds are not affected by the Lightbloom. Incredible! Could there be something about the rift that keeps the Lightbloom in check?' WHERE `ID`=86944;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='So there are no signs of lightbloom yet in their villages? Meeka seems unchanged as well, and states that the rutaani never act in the manner of the light-crazed.

This is both promising and frustrating.

I am glad that it hasn''t yet spread that far, but I suspect we shall find more soon.' WHERE `ID`=86956;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I have given up my connection to the Goddess to protect my people from the dangers of the Rift of Aln. I do not believe anyone should ever go there without knowing what you risk. Haranir will succumb and die without protection.' WHERE `ID`=86836;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='My hands tingle where the Alndust touches. A curious feeling... not unwelcome.

The honored Shul''ka told me how to manipulate the alndust to protect Haranir in the Rift. It seemed difficult, but with its magic swelling in me, I feel that it should be doable.' WHERE `ID`=86851;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='It is sobering to see the effects of the Rift on my peoples. But Amarakk''s interference has given me unintended hope.

I must go into the Rift to search for Hagar''s answer, and with the Shul''ka''s help, I may even survive this ordeal.' WHERE `ID`=86855;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I cannot hear the voice of the Goddess.

I hate it.

How does Amarakk live like this?' WHERE `ID`=86856;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='That manifestation is one of the purest forms of Aln madness that resides here. My ward will distract it only for so long. We must move quickly.' WHERE `ID`=86857;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Another soul saved.

This is why I do this, $n. All my sacrifices, shutting myself from the voice of the Goddess, is worth it for each soul I rescue from the grasp of the Rift.' WHERE `ID`=86858;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I thought I would never see this with my own eyes... and yet here we are.

Make this worth it.' WHERE `ID`=86862;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='The alndust may not be able to recover someone who has fully fallen to the lightbloom, but it should be able to inoculate those from further corruption.

That must be enough.' WHERE `ID`=86866;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='This is troubling news. The Lightbloom hasn''t seemed to affect any haranir thus far. Has it somehow infested the Rootwarden? Or is this his pride speaking? He''s always been a zealous one, but...

We must move quickly.' WHERE `ID`=94677;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='This is so much more than what the Rootwarden said. How has the Lightbloom spread so much, and so quickly?' WHERE `ID`=86882;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Now we can begin.' WHERE `ID`=86867;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='To think that while we toiled below, the Lightbloom would spread so aggressively in Eversong.

Damn it all! Every victory we win reveals rising danger.' WHERE `ID`=86883;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='It is a shame to see something born of Harandar to wreak such havoc on a place like this. These roots may not cradle Aln''hara, but they grow toward her all the same.' WHERE `ID`=86884;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Damn it all. For every rootway you torch. two more crop up elsewhere. It''s like they''re self-perpetuating, spreading in the span of moments.

I don''t think we can solve this with arrows and magic, even with Orweyna''s help. We don''t have enough Alndust, nor enough Haranir to prevent the spread of this frenzy.' WHERE `ID`=86885;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I... I cannot believe it. My kin on the surface, standing shoulder to shoulder with surface-dwellers, and wielding the magics of Aln...

<Orweyna sets her jaw and flashes you a smile.>

But we do not have time for sentiment. We must bring Ruia to justice, and end this frenzy.' WHERE `ID`=86892;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86896,0,0,0,0,'Dire as the situation is, I''d be lying if I said I didn''t value the chance to hunt such exhilarating prey.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='It is over. Though the Lightbloom may never fully recede, its mastermind has been driven back into the rootway. With the frenzy quelled, and the surrounding forests warded against its advance, we can rest assured that Eversong will not suffer the Lightbloom''s spread any longer.

We''ve done it. We''ve won!' WHERE `ID`=86897;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='For the first time in generations, the haranir walk upon the surface of Aln''hara''s creation. Time will tell how her creation receives us in turn.

The fighting is far from over. The Void claws at your gates and threatens your people. But know this, my friend: from this day forward, any threat that encroaches upon Aln''hara''s bounty will have the Hara''ti to contend with, be it here or deep below the earth.' WHERE `ID`=86898;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Thank you for coming, $n. I need your help, as do many of our priests and paladins.

One paladin in particular.' WHERE `ID`=89193;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86837,0,0,0,0,'The Sunwell is north of here, $n. I''ll meet you there.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Welcome to Light''s Hope, $n.

Most of the paladins that defended these grounds were called by the Light. I''ve had to reach out to the Ebon Blade for support, or the scourge would have overrun this holy place.' WHERE `ID`=86839;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Thank you, $n. You''ve thinned their ranks enough that we''ll be able to maintain the defenses, with the help we have from our... allies.

Now, Faol has told me about your need for relics.' WHERE `ID`=86840;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I trust you found what you needed, $n?

To paladins:
I trust you found what you needed, Highlord $n?' WHERE `ID`=86841;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Here we are. Let''s deal with these Scarlets.' WHERE `ID`=86842;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='These weapons of the Light shall serve a much greater purpose, from this day forward.

I hope that may be true as well for Aelyse--the Scarlet champion Arator showed mercy to.

I told her to begin by surrendering herself to Calia Menethil, at the Sunwell.' WHERE `ID`=86844;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Quickly, $n. Let us get these distributed!' WHERE `ID`=92136;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='With those relics, they should be able to sustain the ritual for much longer.

And we can attend to other matters.' WHERE `ID`=86902;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86845,0,0,0,0,'Welcome, $n. There''s plenty to do here if you''re willing!',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Good work, $n. Things are starting to look better.' WHERE `ID`=91000;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Excellent! This will help the people of Hammerfall help themselves.' WHERE `ID`=86846;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86846,0,0,0,0,'Have you distributed the supplies, $n?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Excellent work, $n. We''ll get these reforged into tools, and distribute them to the people.' WHERE `ID`=89338;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Perhaps, in the face of the death of their comrades, others will see sense as I did. At least those you killed won''t dishonor themselves any longer.' WHERE `ID`=86823;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I hope that this might demoralize some of these soldiers out of their misguided devotion to a failed cause.

Regardless, I am glad those banners are not flying any longer.' WHERE `ID`=86824;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='As we defeat their leaders, the Dark Horde presence throughout the Burning Steppes will continue to splinter.

Mar''kag was the first to fall. This was a good first step.' WHERE `ID`=86825;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='That gave ''em a kick in the pants!

See if any of ''em volunteer to lead their warbands now, after that humiliation!' WHERE `ID`=86827;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Did ye destroy their weapons racks?

Aye, that''ll do. We''ve bought everyone nearby a few months of peace while they resupply.' WHERE `ID`=91842;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Did ye get Faol''s relic?

I hope that old priest knows what he''s doing.' WHERE `ID`=86826;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Excellent, $n! I believe this will save many lives across the region. With no warlord to rally them, the Dark Horde should fall apart.' WHERE `ID`=86831;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='You killed many of them, but I watched even more run away.

Let''s hope they never return.' WHERE `ID`=86830;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='These fragments you''ve been recovering might be the most important relics of our journey, $n.' WHERE `ID`=86829;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='It''s a tragic story, but maybe something better can be made o'' it with those fragments of Turalyon''s shield.

Perhaps it can be restored--along with our friend.' WHERE `ID`=91726;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='We certainly did some good in the Burning Steppes, $n, and recovered the fragments of Turalyon''s shield.

Arator seems excited to see it reforged.' WHERE `ID`=86832;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86832,0,0,0,0,'<Name>, I can''t thank you enough for taking this journey with Arator and I.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='<Name>, that did not go as I hoped, to say the least.

I''d hoped he would be able to see... to accept that he could still change.

But it doesn''t look like he''s open to that--at least, not now.' WHERE `ID`=86833;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='This has been a journey, $n.

I''ve learned a lot from Alonsus, and the Sons of Lothar...

And perhaps most of all, what kind of paladin my father used to be, and what sort I''ll be from now on.' WHERE `ID`=86903;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Thank you, $n, for bolstering our defenders at the Sunwell.

It looks like Arator has sorted things out as well, and is ready for whatever may be ahead. It is good to have you both focused on the fight against the Void once more. 

Arator is a good man. I''m grateful we didn''t lose him to this conflict.' WHERE `ID`=91787;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86557,0,0,0,0,'I will not deny, I still thrive in the rush of battle. So long as it is of righteous cause.',0);
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86531,0,0,0,0,'What does she have planned...',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='I''ve seen one of these before. Ethereals use them to encrypt communications.

Excellent find, $n.' WHERE `ID`=86528;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Potent. I can feel the energy--radiant. Glorious.' WHERE `ID`=86538;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Xal''atath.

Let us see this final message.' WHERE `ID`=86537;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (88768,0,0,0,0,'Have you taken them out?',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='A naaru, imprisoned. The Light shall give these monsters no mercy.' WHERE `ID`=86539;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86540,0,0,0,0,'What are you doing here? Place the manacells, now!',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Everything I could muster. It was simply... devoured.' WHERE `ID`=86542;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='What was that...?' WHERE `ID`=86544;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Decimus is a far more capable domanaar than they''ve been letting on.' WHERE `ID`=86545;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Comfortable? So nice to see someone appreciate my hospitality.

Now I suppose we must discuss business before your glowing friend has another tantrum.' WHERE `ID`=86510;
INSERT INTO `world`.`quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES (86510,0,0,0,0,'Have you met my pets? I assure you, they''re harmless. Unless, of course, they''re hungry.',0);
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='There you have it--simply steal the Mantle from Terminas. I''d recommend acting quickly. Who knows when Terminas will return to the Obscurion Citadel.

A shame about Ciphus. I was planning to devour him myself once I''d fattened him up.' WHERE `ID`=90571;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='This is what my mother has battled on her own for all these years? I won''t let her shoulder that burden alone any more.' WHERE `ID`=86513;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Do you sense it? Every beast here either fears you or wants to kill you. Even their mistress cannot ignore you now.' WHERE `ID`=86512;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Well done. Soon we''ll have the Mantle of Predation and no longer need Decimus.

Do not mistake their usefulness for allegiance as Alleria has.' WHERE `ID`=86515;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Good hunting. With the ultradons dead, we may just be able to get out of here alive.' WHERE `ID`=86516;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='This isn''t right, Hieron didn''t come here to die. The Light should protect people, not lead them to their deaths.

<Arator seems lost in thought.>

Thank you. I''ll make sure to give his journal to the others.' WHERE `ID`=86517;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Are you alright? I must have missed something. Why did Decimus bother helping us at all? They could have betrayed us at any time. It doesn''t make any sense...' WHERE `ID`=86518;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Fine work $n. 

There''s plenty to do now that you''ve taken care of those issues.' WHERE `ID`=95276;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='Well done. That Voidstorm is evoking fear and terror in everyone who sees it, myself included. 

But I chose this life of standing up to evil and spitting in its face. Sadly not everyone had the luxury of that being a choice.' WHERE `ID`=91854;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='<Lor''themar raises an eyebrow and frowns slightly. You can tell he is fighting back exasperation and anger.>

This is a... very unexpected turn of events. Yet still more will unfold in front of us, I''m sure.' WHERE `ID`=91087;
UPDATE `world`.`quest_template` SET `QuestCompletionLog`='When Halduron burst into a war council shouting about hidden worlds and ancient warriors, I thought he had gone mad. But now that I''ve seen the haranir with my own eyes...

We are lucky to have them as potential allies. And lucky to have you, I''d say, in brokering that relationship.

There is more for us to do. But I''ve no doubt that the Hara''ti will prove vital allies to Silvermoon in the days to come.' WHERE `ID`=91084;
