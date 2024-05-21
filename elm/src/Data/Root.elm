module Data.Root exposing (..)

--

import Helper.Encode as Encode
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Extra as Decode
import Json.Decode.Pipeline
    exposing
        ( optional
        , required
        )
import Json.Encode as Encode exposing (Value)


type AtContext
    = HttpsColonSlashSlashschemaDotorg


type PersonAttype
    = PersonType


type PlaceAttype
    = PlaceType


type PostalAddressAttype
    = PostalAddressType


type OfferAttype
    = OfferType


type PriceSpecificationAttype
    = PriceSpecificationType


type EventAttype
    = EventType


type ProductionAttype
    = CreativeWorkType
    | PlayType


type OrganizationAttype
    = OrganizationType


type VirtualLocationAttype
    = VirtualLocationType


type PerformanceRoleAttype
    = PerformanceRoleType


type CreatorRoleAttype
    = RoleType


type AudienceAttype
    = PeopleAudienceType


type alias Audience =
    { atType : AudienceAttype
    , audienceType : Maybe String
    , suggestedMaxAge : Maybe Int
    , suggestedMinAge : Maybe Int
    }


type CreatorEntry
    = CreatorEntryPe Person
    | CreatorEntryOr Organization


type alias CreatorRole =
    { atType : CreatorRoleAttype
    , creator : CreatorEntry
    , roleName : Maybe String
    }


type alias Event =
    { atType : EventAttype
    , duration : Maybe Int
    , endDate : Maybe String
    , eventStatus : Maybe EventEventStatus
    , eventType : Maybe (List EventTypeItem)
    , identifier : String
    , intermission : Maybe Int
    , location : Maybe (List LocationItem)
    , offers : Maybe (List Offer)
    , performer : Maybe (List PerformanceRole)
    , previousStartDate : Maybe String
    , startDate : String
    , subtitleLanguage : Maybe String
    , url : Maybe String
    }


type alias Offer =
    { atType : OfferAttype
    , name : Maybe String
    , priceSpecification : PriceSpecification
    , url : Maybe String
    }


type alias Organization =
    { atType : OrganizationAttype
    , address : Maybe PostalAddress
    , logo : Maybe String
    , name : String
    }


type alias PerformanceRole =
    { atType : PerformanceRoleAttype
    , characterName : Maybe String
    , performer : Person
    }


type alias Person =
    { atType : PersonAttype
    , name : String
    }


type alias Place =
    { atType : PlaceAttype
    , address : PostalAddress
    , latitude : Maybe Float
    , longitude : Maybe Float
    , name : Maybe String
    , wheelChairPlaces : Maybe WheelChairPlace
    }


type alias PostalAddress =
    { atType : PostalAddressAttype
    , addressLocality : String
    , postalCode : String
    , streetAddress : Maybe String
    }


type alias Production =
    { atType : ProductionAttype
    , abstract : Maybe String
    , accessModeSufficient : Maybe (List AccessModeSufficientItem)
    , accessibilityHazard : Maybe (List AccessibilityHazardItem)
    , accessibilitySummary : Maybe String
    , additionalInfo : Maybe String
    , audience : Maybe Audience
    , creator : Maybe (List CreatorRole)
    , description : Maybe String
    , events : List Event
    , funder : Maybe (List Organization)
    , genre : Maybe ProductionGenre
    , identifier : String
    , inLanguage : Maybe String
    , name : String
    , productionType : Maybe ProductionProductionType
    , sponsor : Maybe (List Organization)
    , subtitle : Maybe String
    }


type alias Root =
    { atContext : AtContext
    , organization : Organization
    , productions : List Production
    , version : Version
    }


type alias VirtualLocation =
    { atType : VirtualLocationAttype
    , name : Maybe String
    , url : Maybe String
    }


type alias WheelChairPlace =
    { count : Int
    , hasSpaceForAssistant : Maybe Bool
    , wheelchairUserCapacity : Maybe Int
    }


type AccessModeSufficientItem
    = AuditoryAccessModeSufficient
    | TactileAccessModeSufficient
    | TextualAccessModeSufficient
    | VisualAccessModeSufficient


type AccessibilityHazardItem
    = NoneAccessibilityHazard
    | UnknownAccessibilityHazard
    | FlashingHazardAccessibilityHazard
    | MotionSimulationHazardAccessibilityHazard
    | SoundHazardAccessibilityHazard
    | NoFlashingHazardAccessibilityHazard
    | NoMotionSimulationHazardAccessibilityHazard
    | NoSoundHazardAccessibilityHazard
    | UnknownFlashingHazardAccessibilityHazard
    | UnknownMotionSimulationHazardAccessibilityHazard
    | UnknownSoundHazardAccessibilityHazard


type EventEventStatus
    = EventScheduledEvent
    | EventCancelledEvent
    | EventMovedOnlineEvent
    | EventPostponedEvent
    | EventRescheduledEvent


type EventTypeItem
    = PremiereEventType
    | LastShowEventType
    | GuestPerformanceEventType


type ProductionGenre
    = AudiowalkProduction
    | BallettProduction
    | DigitaltheaterProduction
    | FigurentheaterProduction
    | GameTheaterProduction
    | HoerspielProduction
    | ImprotheaterProduction
    | InstallationProduction
    | KabarettComedyProduction
    | KammerkonzertProduction
    | KonzertProduction
    | LecturePerformanceProduction
    | LesungProduction
    | MusicalProduction
    | MusiktheaterProduction
    | ObjekttheaterProduction
    | OperProduction
    | OperetteProduction
    | PerformanceProduction
    | PhysicalTheatreProduction
    | PodcastProduction
    | PuppentheaterProduction
    | SinfoniekonzertProduction
    | SprechtheaterProduction
    | SzenischeLesungProduction
    | SzenischesKonzertProduction
    | TanzProduction
    | TheaterImOeffentlichenRaumProduction
    | WorkshopProduction
    | ZeitgenoessischerTanzProduction


type LocationItem
    = LocationItemPl Place
    | LocationItemVi VirtualLocation


type alias PriceSpecification =
    { atType : PriceSpecificationAttype
    , maxPrice : Maybe Float
    , minPrice : Float
    , priceCurrency : String
    }


type ProductionProductionType
    = WorldPremiereProduction
    | FirstPerformanceProduction
    | RevivalProduction


type Version
    = V2


atContextDecoder : Decoder AtContext
atContextDecoder =
    Decode.string |> Decode.andThen (parseAtContext >> Decode.fromResult)


parseAtContext : String -> Result String AtContext
parseAtContext atContext =
    case atContext of
        "https://schema.org" ->
            Ok HttpsColonSlashSlashschemaDotorg

        _ ->
            Err <| "Unknown atContext type: " ++ atContext


personAttypeDecoder : Decoder PersonAttype
personAttypeDecoder =
    Decode.string |> Decode.andThen (parsePersonAttype >> Decode.fromResult)


parsePersonAttype : String -> Result String PersonAttype
parsePersonAttype personAttype =
    case personAttype of
        "Person" ->
            Ok PersonType

        _ ->
            Err <| "Unknown personAttype type: " ++ personAttype


placeAttypeDecoder : Decoder PlaceAttype
placeAttypeDecoder =
    Decode.string |> Decode.andThen (parsePlaceAttype >> Decode.fromResult)


parsePlaceAttype : String -> Result String PlaceAttype
parsePlaceAttype placeAttype =
    case placeAttype of
        "Place" ->
            Ok PlaceType

        _ ->
            Err <| "Unknown placeAttype type: " ++ placeAttype


postalAddressAttypeDecoder : Decoder PostalAddressAttype
postalAddressAttypeDecoder =
    Decode.string |> Decode.andThen (parsePostalAddressAttype >> Decode.fromResult)


parsePostalAddressAttype : String -> Result String PostalAddressAttype
parsePostalAddressAttype postalAddressAttype =
    case postalAddressAttype of
        "PostalAddress" ->
            Ok PostalAddressType

        _ ->
            Err <| "Unknown postalAddressAttype type: " ++ postalAddressAttype


offerAttypeDecoder : Decoder OfferAttype
offerAttypeDecoder =
    Decode.string |> Decode.andThen (parseOfferAttype >> Decode.fromResult)


parseOfferAttype : String -> Result String OfferAttype
parseOfferAttype offerAttype =
    case offerAttype of
        "Offer" ->
            Ok OfferType

        _ ->
            Err <| "Unknown offerAttype type: " ++ offerAttype


priceSpecificationAttypeDecoder : Decoder PriceSpecificationAttype
priceSpecificationAttypeDecoder =
    Decode.string |> Decode.andThen (parsePriceSpecificationAttype >> Decode.fromResult)


parsePriceSpecificationAttype : String -> Result String PriceSpecificationAttype
parsePriceSpecificationAttype priceSpecificationAttype =
    case priceSpecificationAttype of
        "PriceSpecification" ->
            Ok PriceSpecificationType

        _ ->
            Err <| "Unknown priceSpecificationAttype type: " ++ priceSpecificationAttype


eventAttypeDecoder : Decoder EventAttype
eventAttypeDecoder =
    Decode.string |> Decode.andThen (parseEventAttype >> Decode.fromResult)


parseEventAttype : String -> Result String EventAttype
parseEventAttype eventAttype =
    case eventAttype of
        "Event" ->
            Ok EventType

        _ ->
            Err <| "Unknown eventAttype type: " ++ eventAttype


productionAttypeDecoder : Decoder ProductionAttype
productionAttypeDecoder =
    Decode.string |> Decode.andThen (parseProductionAttype >> Decode.fromResult)


parseProductionAttype : String -> Result String ProductionAttype
parseProductionAttype productionAttype =
    case productionAttype of
        "CreativeWork" ->
            Ok CreativeWorkType

        "Play" ->
            Ok PlayType

        _ ->
            Err <| "Unknown productionAttype type: " ++ productionAttype


organizationAttypeDecoder : Decoder OrganizationAttype
organizationAttypeDecoder =
    Decode.string |> Decode.andThen (parseOrganizationAttype >> Decode.fromResult)


parseOrganizationAttype : String -> Result String OrganizationAttype
parseOrganizationAttype organizationAttype =
    case organizationAttype of
        "Organization" ->
            Ok OrganizationType

        _ ->
            Err <| "Unknown organizationAttype type: " ++ organizationAttype


virtualLocationAttypeDecoder : Decoder VirtualLocationAttype
virtualLocationAttypeDecoder =
    Decode.string |> Decode.andThen (parseVirtualLocationAttype >> Decode.fromResult)


parseVirtualLocationAttype : String -> Result String VirtualLocationAttype
parseVirtualLocationAttype virtualLocationAttype =
    case virtualLocationAttype of
        "VirtualLocation" ->
            Ok VirtualLocationType

        _ ->
            Err <| "Unknown virtualLocationAttype type: " ++ virtualLocationAttype


performanceRoleAttypeDecoder : Decoder PerformanceRoleAttype
performanceRoleAttypeDecoder =
    Decode.string |> Decode.andThen (parsePerformanceRoleAttype >> Decode.fromResult)


parsePerformanceRoleAttype : String -> Result String PerformanceRoleAttype
parsePerformanceRoleAttype performanceRoleAttype =
    case performanceRoleAttype of
        "PerformanceRole" ->
            Ok PerformanceRoleType

        _ ->
            Err <| "Unknown performanceRoleAttype type: " ++ performanceRoleAttype


creatorRoleAttypeDecoder : Decoder CreatorRoleAttype
creatorRoleAttypeDecoder =
    Decode.string |> Decode.andThen (parseCreatorRoleAttype >> Decode.fromResult)


parseCreatorRoleAttype : String -> Result String CreatorRoleAttype
parseCreatorRoleAttype creatorRoleAttype =
    case creatorRoleAttype of
        "Role" ->
            Ok RoleType

        _ ->
            Err <| "Unknown creatorRoleAttype type: " ++ creatorRoleAttype


audienceAttypeDecoder : Decoder AudienceAttype
audienceAttypeDecoder =
    Decode.string |> Decode.andThen (parseAudienceAttype >> Decode.fromResult)


parseAudienceAttype : String -> Result String AudienceAttype
parseAudienceAttype audienceAttype =
    case audienceAttype of
        "PeopleAudience" ->
            Ok PeopleAudienceType

        _ ->
            Err <| "Unknown audienceAttype type: " ++ audienceAttype


audienceDecoder : Decoder Audience
audienceDecoder =
    Decode.succeed Audience
        |> required "@type" audienceAttypeDecoder
        |> optional "audienceType" (Decode.nullable Decode.string) Nothing
        |> optional "suggestedMaxAge" (Decode.nullable Decode.int) Nothing
        |> optional "suggestedMinAge" (Decode.nullable Decode.int) Nothing


creatorEntryDecoder : Decoder CreatorEntry
creatorEntryDecoder =
    Decode.oneOf [ personDecoder |> Decode.map CreatorEntryPe
                 , organizationDecoder |> Decode.map CreatorEntryOr
                 ]


creatorRoleDecoder : Decoder CreatorRole
creatorRoleDecoder =
    Decode.succeed CreatorRole
        |> required "@type" creatorRoleAttypeDecoder
        |> required "creator" creatorEntryDecoder
        |> optional "roleName" (Decode.nullable Decode.string) Nothing


eventDecoder : Decoder Event
eventDecoder =
    Decode.succeed Event
        |> required "@type" eventAttypeDecoder
        |> optional "duration" (Decode.nullable Decode.int) Nothing
        |> optional "endDate" (Decode.nullable Decode.string) Nothing
        |> optional "eventStatus" (Decode.nullable eventEventStatusDecoder) Nothing
        |> optional "eventType" (Decode.nullable eventTypeDecoder) Nothing
        |> required "identifier" Decode.string
        |> optional "intermission" (Decode.nullable Decode.int) Nothing
        |> optional "location" (Decode.nullable locationDecoder) Nothing
        |> optional "offers" (Decode.nullable offersDecoder) Nothing
        |> optional "performer" (Decode.nullable performerDecoder) Nothing
        |> optional "previousStartDate" (Decode.nullable Decode.string) Nothing
        |> required "startDate" Decode.string
        |> optional "subtitleLanguage" (Decode.nullable Decode.string) Nothing
        |> optional "url" (Decode.nullable Decode.string) Nothing


offerDecoder : Decoder Offer
offerDecoder =
    Decode.succeed Offer
        |> required "@type" offerAttypeDecoder
        |> optional "name" (Decode.nullable Decode.string) Nothing
        |> required "priceSpecification" priceSpecificationDecoder
        |> optional "url" (Decode.nullable Decode.string) Nothing


organizationDecoder : Decoder Organization
organizationDecoder =
    Decode.succeed Organization
        |> required "@type" organizationAttypeDecoder
        |> optional "address" (Decode.nullable postalAddressDecoder) Nothing
        |> optional "logo" (Decode.nullable Decode.string) Nothing
        |> required "name" Decode.string


performanceRoleDecoder : Decoder PerformanceRole
performanceRoleDecoder =
    Decode.succeed PerformanceRole
        |> required "@type" performanceRoleAttypeDecoder
        |> optional "characterName" (Decode.nullable Decode.string) Nothing
        |> required "performer" personDecoder


personDecoder : Decoder Person
personDecoder =
    Decode.succeed Person
        |> required "@type" personAttypeDecoder
        |> required "name" Decode.string


placeDecoder : Decoder Place
placeDecoder =
    Decode.succeed Place
        |> required "@type" placeAttypeDecoder
        |> required "address" postalAddressDecoder
        |> optional "latitude" (Decode.nullable Decode.float) Nothing
        |> optional "longitude" (Decode.nullable Decode.float) Nothing
        |> optional "name" (Decode.nullable Decode.string) Nothing
        |> optional "wheelChairPlaces" (Decode.nullable wheelChairPlaceDecoder) Nothing


postalAddressDecoder : Decoder PostalAddress
postalAddressDecoder =
    Decode.succeed PostalAddress
        |> required "@type" postalAddressAttypeDecoder
        |> required "addressLocality" Decode.string
        |> required "postalCode" Decode.string
        |> optional "streetAddress" (Decode.nullable Decode.string) Nothing


productionDecoder : Decoder Production
productionDecoder =
    Decode.succeed Production
        |> required "@type" productionAttypeDecoder
        |> optional "abstract" (Decode.nullable Decode.string) Nothing
        |> optional "accessModeSufficient" (Decode.nullable accessModeSufficientDecoder) Nothing
        |> optional "accessibilityHazard" (Decode.nullable accessibilityHazardDecoder) Nothing
        |> optional "accessibilitySummary" (Decode.nullable Decode.string) Nothing
        |> optional "additionalInfo" (Decode.nullable Decode.string) Nothing
        |> optional "audience" (Decode.nullable audienceDecoder) Nothing
        |> optional "creator" (Decode.nullable creatorDecoder) Nothing
        |> optional "description" (Decode.nullable Decode.string) Nothing
        |> required "events" eventsDecoder
        |> optional "funder" (Decode.nullable funderDecoder) Nothing
        |> optional "genre" (Decode.nullable productionGenreDecoder) Nothing
        |> required "identifier" Decode.string
        |> optional "inLanguage" (Decode.nullable Decode.string) Nothing
        |> required "name" Decode.string
        |> optional "productionType" (Decode.nullable productionProductionTypeDecoder) Nothing
        |> optional "sponsor" (Decode.nullable sponsorDecoder) Nothing
        |> optional "subtitle" (Decode.nullable Decode.string) Nothing


rootDecoder : Decoder Root
rootDecoder =
    Decode.succeed Root
        |> required "@context" atContextDecoder
        |> required "organization" organizationDecoder
        |> required "productions" productionsDecoder
        |> required "version" versionDecoder


virtualLocationDecoder : Decoder VirtualLocation
virtualLocationDecoder =
    Decode.succeed VirtualLocation
        |> required "@type" virtualLocationAttypeDecoder
        |> optional "name" (Decode.nullable Decode.string) Nothing
        |> optional "url" (Decode.nullable Decode.string) Nothing


wheelChairPlaceDecoder : Decoder WheelChairPlace
wheelChairPlaceDecoder =
    Decode.succeed WheelChairPlace
        |> required "count" Decode.int
        |> optional "hasSpaceForAssistant" (Decode.nullable Decode.bool) Nothing
        |> optional "wheelchairUserCapacity" (Decode.nullable Decode.int) Nothing


accessModeSufficientDecoder : Decoder (List AccessModeSufficientItem)
accessModeSufficientDecoder =
    Decode.list accessModeSufficientItemDecoder


accessModeSufficientItemDecoder : Decoder AccessModeSufficientItem
accessModeSufficientItemDecoder =
    Decode.string |> Decode.andThen (parseAccessModeSufficientItem >> Decode.fromResult)


parseAccessModeSufficientItem : String -> Result String AccessModeSufficientItem
parseAccessModeSufficientItem accessModeSufficientItem =
    case accessModeSufficientItem of
        "auditory" ->
            Ok AuditoryAccessModeSufficient

        "tactile" ->
            Ok TactileAccessModeSufficient

        "textual" ->
            Ok TextualAccessModeSufficient

        "visual" ->
            Ok VisualAccessModeSufficient

        _ ->
            Err <| "Unknown accessModeSufficientItem type: " ++ accessModeSufficientItem


accessibilityHazardDecoder : Decoder (List AccessibilityHazardItem)
accessibilityHazardDecoder =
    Decode.list accessibilityHazardItemDecoder


accessibilityHazardItemDecoder : Decoder AccessibilityHazardItem
accessibilityHazardItemDecoder =
    Decode.string |> Decode.andThen (parseAccessibilityHazardItem >> Decode.fromResult)


parseAccessibilityHazardItem : String -> Result String AccessibilityHazardItem
parseAccessibilityHazardItem accessibilityHazardItem =
    case accessibilityHazardItem of
        "none" ->
            Ok NoneAccessibilityHazard

        "unknown" ->
            Ok UnknownAccessibilityHazard

        "flashingHazard" ->
            Ok FlashingHazardAccessibilityHazard

        "motionSimulationHazard" ->
            Ok MotionSimulationHazardAccessibilityHazard

        "soundHazard" ->
            Ok SoundHazardAccessibilityHazard

        "noFlashingHazard" ->
            Ok NoFlashingHazardAccessibilityHazard

        "noMotionSimulationHazard" ->
            Ok NoMotionSimulationHazardAccessibilityHazard

        "noSoundHazard" ->
            Ok NoSoundHazardAccessibilityHazard

        "unknownFlashingHazard" ->
            Ok UnknownFlashingHazardAccessibilityHazard

        "unknownMotionSimulationHazard" ->
            Ok UnknownMotionSimulationHazardAccessibilityHazard

        "unknownSoundHazard" ->
            Ok UnknownSoundHazardAccessibilityHazard

        _ ->
            Err <| "Unknown accessibilityHazardItem type: " ++ accessibilityHazardItem


creatorDecoder : Decoder (List CreatorRole)
creatorDecoder =
    Decode.list creatorRoleDecoder


eventEventStatusDecoder : Decoder EventEventStatus
eventEventStatusDecoder =
    Decode.string |> Decode.andThen (parseEventEventStatus >> Decode.fromResult)


parseEventEventStatus : String -> Result String EventEventStatus
parseEventEventStatus eventEventStatus =
    case eventEventStatus of
        "EventScheduled" ->
            Ok EventScheduledEvent

        "EventCancelled" ->
            Ok EventCancelledEvent

        "EventMovedOnline" ->
            Ok EventMovedOnlineEvent

        "EventPostponed" ->
            Ok EventPostponedEvent

        "EventRescheduled" ->
            Ok EventRescheduledEvent

        _ ->
            Err <| "Unknown eventEventStatus type: " ++ eventEventStatus


eventTypeDecoder : Decoder (List EventTypeItem)
eventTypeDecoder =
    Decode.list eventTypeItemDecoder


eventTypeItemDecoder : Decoder EventTypeItem
eventTypeItemDecoder =
    Decode.string |> Decode.andThen (parseEventTypeItem >> Decode.fromResult)


parseEventTypeItem : String -> Result String EventTypeItem
parseEventTypeItem eventTypeItem =
    case eventTypeItem of
        "Premiere" ->
            Ok PremiereEventType

        "LastShow" ->
            Ok LastShowEventType

        "GuestPerformance" ->
            Ok GuestPerformanceEventType

        _ ->
            Err <| "Unknown eventTypeItem type: " ++ eventTypeItem


eventsDecoder : Decoder (List Event)
eventsDecoder =
    Decode.list eventDecoder


funderDecoder : Decoder (List Organization)
funderDecoder =
    Decode.list organizationDecoder


productionGenreDecoder : Decoder ProductionGenre
productionGenreDecoder =
    Decode.string |> Decode.andThen (parseProductionGenre >> Decode.fromResult)


parseProductionGenre : String -> Result String ProductionGenre
parseProductionGenre productionGenre =
    case productionGenre of
        "audiowalk" ->
            Ok AudiowalkProduction

        "ballett" ->
            Ok BallettProduction

        "digitaltheater" ->
            Ok DigitaltheaterProduction

        "figurentheater" ->
            Ok FigurentheaterProduction

        "game-theater" ->
            Ok GameTheaterProduction

        "hoerspiel" ->
            Ok HoerspielProduction

        "improtheater" ->
            Ok ImprotheaterProduction

        "installation" ->
            Ok InstallationProduction

        "kabarett-comedy" ->
            Ok KabarettComedyProduction

        "kammerkonzert" ->
            Ok KammerkonzertProduction

        "konzert" ->
            Ok KonzertProduction

        "lecture-performance" ->
            Ok LecturePerformanceProduction

        "lesung" ->
            Ok LesungProduction

        "musical" ->
            Ok MusicalProduction

        "musiktheater" ->
            Ok MusiktheaterProduction

        "objekttheater" ->
            Ok ObjekttheaterProduction

        "oper" ->
            Ok OperProduction

        "operette" ->
            Ok OperetteProduction

        "performance" ->
            Ok PerformanceProduction

        "physical-theatre" ->
            Ok PhysicalTheatreProduction

        "podcast" ->
            Ok PodcastProduction

        "puppentheater" ->
            Ok PuppentheaterProduction

        "sinfoniekonzert" ->
            Ok SinfoniekonzertProduction

        "sprechtheater" ->
            Ok SprechtheaterProduction

        "szenische-lesung" ->
            Ok SzenischeLesungProduction

        "szenisches-konzert" ->
            Ok SzenischesKonzertProduction

        "tanz" ->
            Ok TanzProduction

        "theater-im-oeffentlichen-raum" ->
            Ok TheaterImOeffentlichenRaumProduction

        "workshop" ->
            Ok WorkshopProduction

        "zeitgenoessischer-tanz" ->
            Ok ZeitgenoessischerTanzProduction

        _ ->
            Err <| "Unknown productionGenre type: " ++ productionGenre


locationDecoder : Decoder (List LocationItem)
locationDecoder =
    Decode.list locationItemDecoder


locationItemDecoder : Decoder LocationItem
locationItemDecoder =
    Decode.oneOf [ placeDecoder |> Decode.map LocationItemPl
                 , virtualLocationDecoder |> Decode.map LocationItemVi
                 ]


offersDecoder : Decoder (List Offer)
offersDecoder =
    Decode.list offerDecoder


performerDecoder : Decoder (List PerformanceRole)
performerDecoder =
    Decode.list performanceRoleDecoder


priceSpecificationDecoder : Decoder PriceSpecification
priceSpecificationDecoder =
    Decode.succeed PriceSpecification
        |> required "@type" priceSpecificationAttypeDecoder
        |> optional "maxPrice" (Decode.nullable Decode.float) Nothing
        |> required "minPrice" Decode.float
        |> required "priceCurrency" Decode.string


productionProductionTypeDecoder : Decoder ProductionProductionType
productionProductionTypeDecoder =
    Decode.string |> Decode.andThen (parseProductionProductionType >> Decode.fromResult)


parseProductionProductionType : String -> Result String ProductionProductionType
parseProductionProductionType productionProductionType =
    case productionProductionType of
        "WorldPremiere" ->
            Ok WorldPremiereProduction

        "FirstPerformance" ->
            Ok FirstPerformanceProduction

        "Revival" ->
            Ok RevivalProduction

        _ ->
            Err <| "Unknown productionProductionType type: " ++ productionProductionType


productionsDecoder : Decoder (List Production)
productionsDecoder =
    Decode.list productionDecoder


sponsorDecoder : Decoder (List Organization)
sponsorDecoder =
    Decode.list organizationDecoder


versionDecoder : Decoder Version
versionDecoder =
    Decode.string |> Decode.andThen (parseVersion >> Decode.fromResult)


parseVersion : String -> Result String Version
parseVersion version =
    case version of
        "v2" ->
            Ok V2

        _ ->
            Err <| "Unknown version type: " ++ version


encodeAtContext : AtContext -> Value
encodeAtContext atContext =
    atContext |> atContextToString |> Encode.string


atContextToString : AtContext -> String
atContextToString atContext =
    case atContext of
        HttpsColonSlashSlashschemaDotorg ->
            "https://schema.org"


encodePersonAttype : PersonAttype -> Value
encodePersonAttype personAttype =
    personAttype |> personAttypeToString |> Encode.string


personAttypeToString : PersonAttype -> String
personAttypeToString personAttype =
    case personAttype of
        PersonType ->
            "Person"


encodePlaceAttype : PlaceAttype -> Value
encodePlaceAttype placeAttype =
    placeAttype |> placeAttypeToString |> Encode.string


placeAttypeToString : PlaceAttype -> String
placeAttypeToString placeAttype =
    case placeAttype of
        PlaceType ->
            "Place"


encodePostalAddressAttype : PostalAddressAttype -> Value
encodePostalAddressAttype postalAddressAttype =
    postalAddressAttype |> postalAddressAttypeToString |> Encode.string


postalAddressAttypeToString : PostalAddressAttype -> String
postalAddressAttypeToString postalAddressAttype =
    case postalAddressAttype of
        PostalAddressType ->
            "PostalAddress"


encodeOfferAttype : OfferAttype -> Value
encodeOfferAttype offerAttype =
    offerAttype |> offerAttypeToString |> Encode.string


offerAttypeToString : OfferAttype -> String
offerAttypeToString offerAttype =
    case offerAttype of
        OfferType ->
            "Offer"


encodePriceSpecificationAttype : PriceSpecificationAttype -> Value
encodePriceSpecificationAttype priceSpecificationAttype =
    priceSpecificationAttype |> priceSpecificationAttypeToString |> Encode.string


priceSpecificationAttypeToString : PriceSpecificationAttype -> String
priceSpecificationAttypeToString priceSpecificationAttype =
    case priceSpecificationAttype of
        PriceSpecificationType ->
            "PriceSpecification"


encodeEventAttype : EventAttype -> Value
encodeEventAttype eventAttype =
    eventAttype |> eventAttypeToString |> Encode.string


eventAttypeToString : EventAttype -> String
eventAttypeToString eventAttype =
    case eventAttype of
        EventType ->
            "Event"


encodeProductionAttype : ProductionAttype -> Value
encodeProductionAttype productionAttype =
    productionAttype |> productionAttypeToString |> Encode.string


productionAttypeToString : ProductionAttype -> String
productionAttypeToString productionAttype =
    case productionAttype of
        CreativeWorkType ->
            "CreativeWork"

        PlayType ->
            "Play"


encodeOrganizationAttype : OrganizationAttype -> Value
encodeOrganizationAttype organizationAttype =
    organizationAttype |> organizationAttypeToString |> Encode.string


organizationAttypeToString : OrganizationAttype -> String
organizationAttypeToString organizationAttype =
    case organizationAttype of
        OrganizationType ->
            "Organization"


encodeVirtualLocationAttype : VirtualLocationAttype -> Value
encodeVirtualLocationAttype virtualLocationAttype =
    virtualLocationAttype |> virtualLocationAttypeToString |> Encode.string


virtualLocationAttypeToString : VirtualLocationAttype -> String
virtualLocationAttypeToString virtualLocationAttype =
    case virtualLocationAttype of
        VirtualLocationType ->
            "VirtualLocation"


encodePerformanceRoleAttype : PerformanceRoleAttype -> Value
encodePerformanceRoleAttype performanceRoleAttype =
    performanceRoleAttype |> performanceRoleAttypeToString |> Encode.string


performanceRoleAttypeToString : PerformanceRoleAttype -> String
performanceRoleAttypeToString performanceRoleAttype =
    case performanceRoleAttype of
        PerformanceRoleType ->
            "PerformanceRole"


encodeCreatorRoleAttype : CreatorRoleAttype -> Value
encodeCreatorRoleAttype creatorRoleAttype =
    creatorRoleAttype |> creatorRoleAttypeToString |> Encode.string


creatorRoleAttypeToString : CreatorRoleAttype -> String
creatorRoleAttypeToString creatorRoleAttype =
    case creatorRoleAttype of
        RoleType ->
            "Role"


encodeAudienceAttype : AudienceAttype -> Value
encodeAudienceAttype audienceAttype =
    audienceAttype |> audienceAttypeToString |> Encode.string


audienceAttypeToString : AudienceAttype -> String
audienceAttypeToString audienceAttype =
    case audienceAttype of
        PeopleAudienceType ->
            "PeopleAudience"


encodeAudience : Audience -> Value
encodeAudience audience =
    []
        |> Encode.required "@type" audience.atType encodeAudienceAttype
        |> Encode.optional "audienceType" audience.audienceType Encode.string
        |> Encode.optional "suggestedMaxAge" audience.suggestedMaxAge Encode.int
        |> Encode.optional "suggestedMinAge" audience.suggestedMinAge Encode.int
        |> Encode.object


encodeCreatorEntry : CreatorEntry -> Value
encodeCreatorEntry creatorEntry =
    case creatorEntry of
        CreatorEntryPe person ->
            encodePerson person

        CreatorEntryOr organization ->
            encodeOrganization organization


encodeCreatorRole : CreatorRole -> Value
encodeCreatorRole creatorRole =
    []
        |> Encode.required "@type" creatorRole.atType encodeCreatorRoleAttype
        |> Encode.required "creator" creatorRole.creator encodeCreatorEntry
        |> Encode.optional "roleName" creatorRole.roleName Encode.string
        |> Encode.object


encodeEvent : Event -> Value
encodeEvent event =
    []
        |> Encode.required "@type" event.atType encodeEventAttype
        |> Encode.optional "duration" event.duration Encode.int
        |> Encode.optional "endDate" event.endDate Encode.string
        |> Encode.optional "eventStatus" event.eventStatus encodeEventEventStatus
        |> Encode.optional "eventType" event.eventType encodeEventType
        |> Encode.required "identifier" event.identifier Encode.string
        |> Encode.optional "intermission" event.intermission Encode.int
        |> Encode.optional "location" event.location encodeLocation
        |> Encode.optional "offers" event.offers encodeOffers
        |> Encode.optional "performer" event.performer encodePerformer
        |> Encode.optional "previousStartDate" event.previousStartDate Encode.string
        |> Encode.required "startDate" event.startDate Encode.string
        |> Encode.optional "subtitleLanguage" event.subtitleLanguage Encode.string
        |> Encode.optional "url" event.url Encode.string
        |> Encode.object


encodeOffer : Offer -> Value
encodeOffer offer =
    []
        |> Encode.required "@type" offer.atType encodeOfferAttype
        |> Encode.optional "name" offer.name Encode.string
        |> Encode.required "priceSpecification" offer.priceSpecification encodePriceSpecification
        |> Encode.optional "url" offer.url Encode.string
        |> Encode.object


encodeOrganization : Organization -> Value
encodeOrganization organization =
    []
        |> Encode.required "@type" organization.atType encodeOrganizationAttype
        |> Encode.optional "address" organization.address encodePostalAddress
        |> Encode.optional "logo" organization.logo Encode.string
        |> Encode.required "name" organization.name Encode.string
        |> Encode.object


encodePerformanceRole : PerformanceRole -> Value
encodePerformanceRole performanceRole =
    []
        |> Encode.required "@type" performanceRole.atType encodePerformanceRoleAttype
        |> Encode.optional "characterName" performanceRole.characterName Encode.string
        |> Encode.required "performer" performanceRole.performer encodePerson
        |> Encode.object


encodePerson : Person -> Value
encodePerson person =
    []
        |> Encode.required "@type" person.atType encodePersonAttype
        |> Encode.required "name" person.name Encode.string
        |> Encode.object


encodePlace : Place -> Value
encodePlace place =
    []
        |> Encode.required "@type" place.atType encodePlaceAttype
        |> Encode.required "address" place.address encodePostalAddress
        |> Encode.optional "latitude" place.latitude Encode.float
        |> Encode.optional "longitude" place.longitude Encode.float
        |> Encode.optional "name" place.name Encode.string
        |> Encode.optional "wheelChairPlaces" place.wheelChairPlaces encodeWheelChairPlace
        |> Encode.object


encodePostalAddress : PostalAddress -> Value
encodePostalAddress postalAddress =
    []
        |> Encode.required "@type" postalAddress.atType encodePostalAddressAttype
        |> Encode.required "addressLocality" postalAddress.addressLocality Encode.string
        |> Encode.required "postalCode" postalAddress.postalCode Encode.string
        |> Encode.optional "streetAddress" postalAddress.streetAddress Encode.string
        |> Encode.object


encodeProduction : Production -> Value
encodeProduction production =
    []
        |> Encode.required "@type" production.atType encodeProductionAttype
        |> Encode.optional "abstract" production.abstract Encode.string
        |> Encode.optional "accessModeSufficient" production.accessModeSufficient encodeAccessModeSufficient
        |> Encode.optional "accessibilityHazard" production.accessibilityHazard encodeAccessibilityHazard
        |> Encode.optional "accessibilitySummary" production.accessibilitySummary Encode.string
        |> Encode.optional "additionalInfo" production.additionalInfo Encode.string
        |> Encode.optional "audience" production.audience encodeAudience
        |> Encode.optional "creator" production.creator encodeCreator
        |> Encode.optional "description" production.description Encode.string
        |> Encode.required "events" production.events encodeEvents
        |> Encode.optional "funder" production.funder encodeFunder
        |> Encode.optional "genre" production.genre encodeProductionGenre
        |> Encode.required "identifier" production.identifier Encode.string
        |> Encode.optional "inLanguage" production.inLanguage Encode.string
        |> Encode.required "name" production.name Encode.string
        |> Encode.optional "productionType" production.productionType encodeProductionProductionType
        |> Encode.optional "sponsor" production.sponsor encodeSponsor
        |> Encode.optional "subtitle" production.subtitle Encode.string
        |> Encode.object


encodeRoot : Root -> Value
encodeRoot root =
    []
        |> Encode.required "@context" root.atContext encodeAtContext
        |> Encode.required "organization" root.organization encodeOrganization
        |> Encode.required "productions" root.productions encodeProductions
        |> Encode.required "version" root.version encodeVersion
        |> Encode.object


encodeVirtualLocation : VirtualLocation -> Value
encodeVirtualLocation virtualLocation =
    []
        |> Encode.required "@type" virtualLocation.atType encodeVirtualLocationAttype
        |> Encode.optional "name" virtualLocation.name Encode.string
        |> Encode.optional "url" virtualLocation.url Encode.string
        |> Encode.object


encodeWheelChairPlace : WheelChairPlace -> Value
encodeWheelChairPlace wheelChairPlace =
    []
        |> Encode.required "count" wheelChairPlace.count Encode.int
        |> Encode.optional "hasSpaceForAssistant" wheelChairPlace.hasSpaceForAssistant Encode.bool
        |> Encode.optional "wheelchairUserCapacity" wheelChairPlace.wheelchairUserCapacity Encode.int
        |> Encode.object


encodeAccessModeSufficient : List AccessModeSufficientItem -> Value
encodeAccessModeSufficient accessModeSufficient =
    accessModeSufficient
        |> Encode.list encodeAccessModeSufficientItem


encodeAccessModeSufficientItem : AccessModeSufficientItem -> Value
encodeAccessModeSufficientItem accessModeSufficientItem =
    accessModeSufficientItem |> accessModeSufficientItemToString |> Encode.string


accessModeSufficientItemToString : AccessModeSufficientItem -> String
accessModeSufficientItemToString accessModeSufficientItem =
    case accessModeSufficientItem of
        AuditoryAccessModeSufficient ->
            "auditory"

        TactileAccessModeSufficient ->
            "tactile"

        TextualAccessModeSufficient ->
            "textual"

        VisualAccessModeSufficient ->
            "visual"


encodeAccessibilityHazard : List AccessibilityHazardItem -> Value
encodeAccessibilityHazard accessibilityHazard =
    accessibilityHazard
        |> Encode.list encodeAccessibilityHazardItem


encodeAccessibilityHazardItem : AccessibilityHazardItem -> Value
encodeAccessibilityHazardItem accessibilityHazardItem =
    accessibilityHazardItem |> accessibilityHazardItemToString |> Encode.string


accessibilityHazardItemToString : AccessibilityHazardItem -> String
accessibilityHazardItemToString accessibilityHazardItem =
    case accessibilityHazardItem of
        NoneAccessibilityHazard ->
            "none"

        UnknownAccessibilityHazard ->
            "unknown"

        FlashingHazardAccessibilityHazard ->
            "flashingHazard"

        MotionSimulationHazardAccessibilityHazard ->
            "motionSimulationHazard"

        SoundHazardAccessibilityHazard ->
            "soundHazard"

        NoFlashingHazardAccessibilityHazard ->
            "noFlashingHazard"

        NoMotionSimulationHazardAccessibilityHazard ->
            "noMotionSimulationHazard"

        NoSoundHazardAccessibilityHazard ->
            "noSoundHazard"

        UnknownFlashingHazardAccessibilityHazard ->
            "unknownFlashingHazard"

        UnknownMotionSimulationHazardAccessibilityHazard ->
            "unknownMotionSimulationHazard"

        UnknownSoundHazardAccessibilityHazard ->
            "unknownSoundHazard"


encodeCreator : List CreatorRole -> Value
encodeCreator creator =
    creator
        |> Encode.list encodeCreatorRole


encodeEventEventStatus : EventEventStatus -> Value
encodeEventEventStatus eventEventStatus =
    eventEventStatus |> eventEventStatusToString |> Encode.string


eventEventStatusToString : EventEventStatus -> String
eventEventStatusToString eventEventStatus =
    case eventEventStatus of
        EventScheduledEvent ->
            "EventScheduled"

        EventCancelledEvent ->
            "EventCancelled"

        EventMovedOnlineEvent ->
            "EventMovedOnline"

        EventPostponedEvent ->
            "EventPostponed"

        EventRescheduledEvent ->
            "EventRescheduled"


encodeEventType : List EventTypeItem -> Value
encodeEventType eventType =
    eventType
        |> Encode.list encodeEventTypeItem


encodeEventTypeItem : EventTypeItem -> Value
encodeEventTypeItem eventTypeItem =
    eventTypeItem |> eventTypeItemToString |> Encode.string


eventTypeItemToString : EventTypeItem -> String
eventTypeItemToString eventTypeItem =
    case eventTypeItem of
        PremiereEventType ->
            "Premiere"

        LastShowEventType ->
            "LastShow"

        GuestPerformanceEventType ->
            "GuestPerformance"


encodeEvents : List Event -> Value
encodeEvents events =
    events
        |> Encode.list encodeEvent


encodeFunder : List Organization -> Value
encodeFunder funder =
    funder
        |> Encode.list encodeOrganization


encodeProductionGenre : ProductionGenre -> Value
encodeProductionGenre productionGenre =
    productionGenre |> productionGenreToString |> Encode.string


productionGenreToString : ProductionGenre -> String
productionGenreToString productionGenre =
    case productionGenre of
        AudiowalkProduction ->
            "audiowalk"

        BallettProduction ->
            "ballett"

        DigitaltheaterProduction ->
            "digitaltheater"

        FigurentheaterProduction ->
            "figurentheater"

        GameTheaterProduction ->
            "game-theater"

        HoerspielProduction ->
            "hoerspiel"

        ImprotheaterProduction ->
            "improtheater"

        InstallationProduction ->
            "installation"

        KabarettComedyProduction ->
            "kabarett-comedy"

        KammerkonzertProduction ->
            "kammerkonzert"

        KonzertProduction ->
            "konzert"

        LecturePerformanceProduction ->
            "lecture-performance"

        LesungProduction ->
            "lesung"

        MusicalProduction ->
            "musical"

        MusiktheaterProduction ->
            "musiktheater"

        ObjekttheaterProduction ->
            "objekttheater"

        OperProduction ->
            "oper"

        OperetteProduction ->
            "operette"

        PerformanceProduction ->
            "performance"

        PhysicalTheatreProduction ->
            "physical-theatre"

        PodcastProduction ->
            "podcast"

        PuppentheaterProduction ->
            "puppentheater"

        SinfoniekonzertProduction ->
            "sinfoniekonzert"

        SprechtheaterProduction ->
            "sprechtheater"

        SzenischeLesungProduction ->
            "szenische-lesung"

        SzenischesKonzertProduction ->
            "szenisches-konzert"

        TanzProduction ->
            "tanz"

        TheaterImOeffentlichenRaumProduction ->
            "theater-im-oeffentlichen-raum"

        WorkshopProduction ->
            "workshop"

        ZeitgenoessischerTanzProduction ->
            "zeitgenoessischer-tanz"


encodeLocation : List LocationItem -> Value
encodeLocation location =
    location
        |> Encode.list encodeLocationItem


encodeLocationItem : LocationItem -> Value
encodeLocationItem locationItem =
    case locationItem of
        LocationItemPl place ->
            encodePlace place

        LocationItemVi virtualLocation ->
            encodeVirtualLocation virtualLocation


encodeOffers : List Offer -> Value
encodeOffers offers =
    offers
        |> Encode.list encodeOffer


encodePerformer : List PerformanceRole -> Value
encodePerformer performer =
    performer
        |> Encode.list encodePerformanceRole


encodePriceSpecification : PriceSpecification -> Value
encodePriceSpecification priceSpecification =
    []
        |> Encode.required "@type" priceSpecification.atType encodePriceSpecificationAttype
        |> Encode.optional "maxPrice" priceSpecification.maxPrice Encode.float
        |> Encode.required "minPrice" priceSpecification.minPrice Encode.float
        |> Encode.required "priceCurrency" priceSpecification.priceCurrency Encode.string
        |> Encode.object


encodeProductionProductionType : ProductionProductionType -> Value
encodeProductionProductionType productionProductionType =
    productionProductionType |> productionProductionTypeToString |> Encode.string


productionProductionTypeToString : ProductionProductionType -> String
productionProductionTypeToString productionProductionType =
    case productionProductionType of
        WorldPremiereProduction ->
            "WorldPremiere"

        FirstPerformanceProduction ->
            "FirstPerformance"

        RevivalProduction ->
            "Revival"


encodeProductions : List Production -> Value
encodeProductions productions =
    productions
        |> Encode.list encodeProduction


encodeSponsor : List Organization -> Value
encodeSponsor sponsor =
    sponsor
        |> Encode.list encodeOrganization


encodeVersion : Version -> Value
encodeVersion version =
    version |> versionToString |> Encode.string


versionToString : Version -> String
versionToString version =
    case version of
        V2 ->
            "v2"
