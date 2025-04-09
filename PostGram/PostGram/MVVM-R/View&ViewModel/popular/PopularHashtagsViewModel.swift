//
//  PopularHashtagsViewModel.swift
//  PostGram
//
//  Created by Mert Türedü on 6.04.2025.
//

import Foundation

class PopularHashtagsViewModel: ObservableObject {
    
    @Published var selectedModel: CategoriesModel?
    
    init(selectedModel: CategoriesModel? = nil) {
        self.selectedModel = selectedModel
    }
    
    
}

extension PopularHashtagsViewModel {
    
    func makeCategories() -> [CategoriesModel] {
        [
            .init(id: 1, emoji: "🔥", name: "Popular", hashtags: (
                ["#trending", "#viral", "#popular", "#instafamous", "#explore", "#trendalert", "#viralpost", "#trending2025", "#hotrightnow", "#popularcontent", "#explorepage", "#discovernow", "#trendingtoday", "#ontrend", "#contentcreator"],
                ["#followme", "#followback", "#follow4follow", "#followforfollow", "#followers", "#followtrain", "#followforfollowback", "#followalways", "#followmepage", "#followspree", "#activefollowers", "#followersrealgrowth", "#followersincrease", "#follownow", "#followandlike"],
                ["#like4like", "#likeforlike", "#likeback", "#likeforlikes", "#liketime", "#likenow", "#likers", "#likesforlikes", "#likephoto", "#doubleTap", "#likeall", "#likeforfollow", "#likeplease", "#liketolike", "#appreciatelikes"]
            )),
            .init(id: 2, emoji: "✈️", name: "Travel", hashtags: (
                ["#travel", "#wanderlust", "#adventure", "#vacation", "#exploremore", "#travelgram", "#travelphotography", "#traveltheworld", "#explorer", "#travelbug", "#travelholic", "#travellife", "#globetrotter", "#adventureseeker", "#doyoutravel"],
                ["#travelblogger", "#travelgram", "#instatravel", "#traveladdict", "#travelphotography", "#nomadlife", "#wanderingphotographers", "#travelinfluencer", "#travelpartner", "#worldtravellers", "#travelpreneur", "#travelcommunity", "#travelexpert", "#travelpro", "#nomadictraveller"],
                ["#beautifuldestinations", "#traveltheworld", "#travelholic", "#adventuretime", "#passportready", "#worldexploration", "#wandereratheart", "#exploretheglobe", "#travelinspiration", "#travelpassion", "#travelstoke", "#sunsettravel", "#tropicalparadise", "#perfectdestination", "#amazingplaces"]
            )),
            .init(id: 3, emoji: "👜", name: "Fashion", hashtags: (
                ["#fashion", "#style", "#ootd", "#outfit", "#fashionista", "#fashionweek", "#fashionstyle", "#styleoftheday", "#styleinspiration", "#highfashion", "#fashionforward", "#streetwear", "#fashiondaily", "#fashionaddict", "#trendsetter"],
                ["#instafashion", "#fashionblogger", "#streetstyle", "#fashionable", "#fashionstyle", "#fashioninfluencer", "#stylegram", "#fashioninspo", "#fashiongoals", "#styleblogger", "#fashionlover", "#stylewatch", "#fashionphotography", "#fashioninsta", "#styleblog"],
                ["#stylish", "#styleinspo", "#lookoftheday", "#fashionlover", "#fashionaddict", "#outfitgoals", "#stylegram", "#fashiontrends", "#trendalert", "#stylestatement", "#casualchic", "#modernstyle", "#classicstyle", "#luxuryfashion", "#outfitoftheday"]
            )),
            .init(id: 4, emoji: "💃", name: "Social", hashtags: (
                ["#friends", "#sociallife", "#party", "#events", "#community", "#socializing", "#hangout", "#nightlife", "#socialcircle", "#gathering", "#celebration", "#societytoday", "#peopleconnection", "#socialinteraction", "#togetherness"],
                ["#networking", "#socialmedia", "#socialize", "#meetup", "#connection", "#networkingparty", "#meetpeople", "#businessnetworking", "#professionalconnection", "#socialcapital", "#communityengagement", "#communitybuilding", "#relationshipbuilding", "#interactiondesign", "#interconnected"],
                ["#goodtimes", "#friendship", "#socialgathering", "#peopleconnect", "#socialscene", "#memorableevents", "#friendsforever", "#bonding", "#togetherness", "#socialbutterfly", "#peopleskills", "#humanconnection", "#positivesocialimpact", "#meaningfulconnections", "#socialecosystem"]
            )),
            .init(id: 5, emoji: "👠", name: "Brands", hashtags: (
                ["#brandambassador", "#sponsored", "#luxury", "#designer", "#brandlove", "#premiumbrands", "#brandsofinstagram", "#qualityproducts", "#brandhighlight", "#iconicbrands", "#luxurylifestyle", "#designerlabels", "#signaturebrands", "#brandidentity", "#brandpersonality"],
                ["#fashionbrands", "#luxurybrands", "#brandstyle", "#premiumbrands", "#brandsofinstagram", "#brandcommunity", "#brandawareness", "#branddevelopment", "#brandstrategy", "#brandimage", "#brandvisibility", "#brandengagement", "#brandevolution", "#brandinfluence", "#brandmarketing"],
                ["#brandsupport", "#brandloyal", "#qualitybrand", "#brandreputation", "#favoritebrands", "#brandexperience", "#brandrelationship", "#brandtrust", "#brandquality", "#customerexperience", "#brandvalue", "#brandheritage", "#productexcellence", "#premiumquality", "#brandadvocate"]
            )),
            .init(id: 6, emoji: "🌍", name: "Countries", hashtags: (
                ["#italy", "#france", "#japan", "#usa", "#australia", "#newzealand", "#switzerland", "#canada", "#germany", "#spain", "#brazil", "#sweden", "#greece", "#thailand", "#morocco"],
                ["#worldtravel", "#countrylife", "#expatlife", "#internationalliving", "#globetrotter", "#culturalexperience", "#crosscultural", "#travelabroad", "#countriesoftheworld", "#worldcitizen", "#nationalidentity", "#passportstamp", "#internationaltraveller", "#worldcultures", "#foreignlands"],
                ["#worldexplorer", "#countrysidedreams", "#traveltheworld", "#destinationearth", "#worldplaces", "#globaladventure", "#worldheritagesites", "#passportcollector", "#countryhopping", "#aroundtheworld", "#earthscenery", "#internationalwonders", "#globallandmarks", "#worldtraveller", "#planetexploration"]
            )),
            .init(id: 7, emoji: "🤾🏼‍♂️", name: "Activity", hashtags: (
                ["#outdoors", "#hiking", "#surfing", "#kayaking", "#rockclimbing", "#camping", "#cycling", "#canoeing", "#mountainbiking", "#trailrunning", "#skiing", "#snowboarding", "#scubadiving", "#parasailing", "#bungejumping"],
                ["#activityday", "#activelifestyle", "#getoutside", "#adventure", "#funactivities", "#outdoorfitness", "#extremesports", "#activelife", "#adventuresports", "#outdoorenthusiast", "#fitnessactivities", "#sportylifestyle", "#activepursuits", "#actionactivities", "#recreationalactivities"],
                ["#experiencelife", "#tryitout", "#newexperiences", "#bucketlist", "#activities", "#adventuretime", "#lifestyleactivities", "#experientialliving", "#outdoorlife", "#activityplanner", "#weekendactivities", "#familyactivities", "#groupactivities", "#adventurers", "#liveyourbestlife"]
            )),
            .init(id: 8, emoji: "🏋🏼‍♀️", name: "Fitness", hashtags: (
                ["#fitness", "#workout", "#gym", "#fitnessmotivation", "#healthylifestyle", "#bodybuilding", "#strength", "#cardio", "#training", "#exercise", "#fitlife", "#fitnessgoals", "#weightlifting", "#powerlifting", "#functionaltraining"],
                ["#fitfam", "#fitnesscommunity", "#fitnessjourney", "#gymlife", "#fitnessaddict", "#fitnessenthusiast", "#fitspiration", "#fitnessprofessional", "#fitnesscoach", "#fitnessprogram", "#fitnesstransformation", "#fitnessculture", "#fitnesslifestyle", "#fitnessmindset", "#fitnesschallenge"],
                ["#fitspo", "#fitnessinspiration", "#healthyhabits", "#strongnotskinny", "#workoutmotivation", "#gainz", "#fitbody", "#personaltrainer", "#fitgoals", "#activebody", "#fitmind", "#fitforlife", "#strengthtraining", "#musclebuilding", "#crossfit"]
            )),
            .init(id: 9, emoji: "🎮", name: "Gaming", hashtags: (
                ["#gaming", "#gamer", "#videogames", "#esports", "#gaminglife", "#pcgaming", "#consolegaming", "#mobilegaming", "#rpg", "#fps", "#mmorpg", "#indiegame", "#gamedev", "#retrogaming", "#gamingsetup"],
                ["#gamingcommunity", "#gamersofinstagram", "#gamingsetup", "#gamingpc", "#consolegaming", "#gamersunite", "#progamer", "#gamestreamer", "#gaminginfluencer", "#gaminggroup", "#gamingculture", "#gamerlifestyle", "#gamerconnect", "#streamingcommunity", "#onlinegaming"],
                ["#gamerlife", "#gamingmemes", "#gamenight", "#gamingislife", "#proplayer", "#gamecollector", "#gamingrig", "#gamingstation", "#gaminggear", "#competitivegaming", "#gamingmoments", "#gamingheadset", "#gamingchair", "#gamerelease", "#gamerroom"]
            )),
            .init(id: 10, emoji: "🏖️", name: "Holidays", hashtags: (
                ["#holiday", "#vacation", "#summervacation", "#holidayseason", "#holidaymood", "#winterholiday", "#springbreak", "#autumnbreak", "#seasideholiday", "#islandvacation", "#holidaygetaway", "#familyvacation", "#citybreak", "#staycation", "#longweekend"],
                ["#holidayfun", "#holidayvibes", "#holidaytrip", "#holidayspirit", "#holidaytime", "#holidaydestination", "#vacaymode", "#vacationtime", "#vacationstyle", "#holidayhappiness", "#vacationvibes", "#holidayplanning", "#dreamvacation", "#bestholiday", "#perfectholiday"],
                ["#sunandbeach", "#relaxation", "#holidaydestination", "#traveldiaries", "#getaway", "#beachholiday", "#sunbathing", "#beachlife", "#tropicalvacation", "#allinclusiveresort", "#luxuryresort", "#holidayinn", "#poolsiderelaxation", "#holidayluxury", "#travelandleisure"]
            ))
        ]
    }
    
}
