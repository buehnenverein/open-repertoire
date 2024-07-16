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


type OrganizationAttype
    = OrganizationType


type VirtualLocationAttype
    = VirtualLocationType


type CreatorRoleAttype
    = RoleType


type PerformanceRoleAttype
    = PerformanceRoleType


type AudienceAttype
    = PeopleAudienceType


type alias Audience =
    { atType : AudienceAttype
    , audienceType : Maybe String
    , suggestedMaxAge : Maybe Int
    , suggestedMinAge : Maybe Int
    }


type DefinitionsCommonCreativeWorkType
    = CreativeWorkDefinitions
    | PlayDefinitions


type DefinitionsCommonEventType
    = EventDefinitions


type alias CreatorRoleItem =
    { atType : CreatorRoleAttype
    , creator : List PersonOrOrganization
    , roleName : Maybe String
    }


type alias Event =
    { atType : DefinitionsCommonEventType
    , additionalOffering : Maybe (List Offering)
    , doorTime : Maybe String
    , duration : Maybe Int
    , endDate : Maybe String
    , eventStatus : Maybe EventEventStatus
    , eventType : Maybe (List EventTypeItem)
    , identifier : String
    , intermission : Maybe Int
    , location : Maybe (List LocationItem)
    , offers : Maybe (List Offer)
    , performer : Maybe (List PerformanceRoleItem)
    , previousStartDate : Maybe String
    , startDate : String
    , subtitleLanguage : Maybe String
    , url : Maybe String
    }


type alias Offer =
    { atType : OfferAttype
    , availability : Maybe OfferAvailability
    , name : Maybe String
    , priceSpecification : PriceSpecification
    , url : Maybe String
    }


type alias Offering =
    { atType : DefinitionsCommonEventType
    , description : Maybe String
    , duration : Maybe Int
    , endDate : Maybe String
    , location : Maybe String
    , name : String
    , startDate : Maybe String
    }


type alias Organization =
    { atType : OrganizationAttype
    , address : Maybe PostalAddress
    , logo : Maybe String
    , name : String
    }


type alias OriginalWork =
    { atType : DefinitionsCommonCreativeWorkType
    , author : Maybe (List Person)
    , name : String
    , translator : Maybe (List PersonOrOrganization)
    }


type alias PerformanceRoleItem =
    { atType : PerformanceRoleAttype
    , characterName : Maybe String
    , performer : List PersonOrOrganization
    }


type alias Person =
    { atType : PersonAttype
    , name : String
    }


type PersonOrOrganization
    = PersonOrOrganizationPe Person
    | PersonOrOrganizationOr Organization


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
    { atType : DefinitionsCommonCreativeWorkType
    , abstract : Maybe String
    , accessModeSufficient : Maybe (List AccessModeSufficientItem)
    , accessibilityHazard : Maybe (List AccessibilityHazardItem)
    , accessibilitySummary : Maybe String
    , additionalInfo : Maybe String
    , audience : Maybe Audience
    , creator : Maybe (List CreatorRoleItem)
    , description : Maybe String
    , events : List Event
    , funder : Maybe (List Organization)
    , genre : Maybe (List GenreItem)
    , identifier : String
    , inLanguage : Maybe String
    , isBasedOn : Maybe OriginalWork
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
    , description : Maybe String
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


type OfferAvailability
    = InStockOffer
    | SoldOutOffer


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
    | PreviewEventType


type GenreItem
    = AudiowalkGenre
    | BallettGenre
    | DigitaltheaterGenre
    | FigurentheaterGenre
    | GameTheaterGenre
    | HoerspielGenre
    | ImprotheaterGenre
    | InstallationGenre
    | KabarettComedyGenre
    | KammerkonzertGenre
    | KonzertGenre
    | LecturePerformanceGenre
    | LesungGenre
    | MusicalGenre
    | MusiktheaterGenre
    | ObjekttheaterGenre
    | OperGenre
    | OperetteGenre
    | PerformanceGenre
    | PhysicalTheatreGenre
    | PodcastGenre
    | PuppentheaterGenre
    | SinfoniekonzertGenre
    | SprechtheaterGenre
    | SzenischeLesungGenre
    | SzenischesKonzertGenre
    | TanzGenre
    | TheaterImOeffentlichenRaumGenre
    | WorkshopGenre
    | ZeitgenoessischerTanzGenre


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


definitionsCommonCreativeWorkTypeDecoder : Decoder DefinitionsCommonCreativeWorkType
definitionsCommonCreativeWorkTypeDecoder =
    Decode.string |> Decode.andThen (parseDefinitionsCommonCreativeWorkType >> Decode.fromResult)


parseDefinitionsCommonCreativeWorkType : String -> Result String DefinitionsCommonCreativeWorkType
parseDefinitionsCommonCreativeWorkType definitionsCommonCreativeWorkType =
    case definitionsCommonCreativeWorkType of
        "CreativeWork" ->
            Ok CreativeWorkDefinitions

        "Play" ->
            Ok PlayDefinitions

        _ ->
            Err <| "Unknown definitionsCommonCreativeWorkType type: " ++ definitionsCommonCreativeWorkType


definitionsCommonEventTypeDecoder : Decoder DefinitionsCommonEventType
definitionsCommonEventTypeDecoder =
    Decode.string |> Decode.andThen (parseDefinitionsCommonEventType >> Decode.fromResult)


parseDefinitionsCommonEventType : String -> Result String DefinitionsCommonEventType
parseDefinitionsCommonEventType definitionsCommonEventType =
    case definitionsCommonEventType of
        "Event" ->
            Ok EventDefinitions

        _ ->
            Err <| "Unknown definitionsCommonEventType type: " ++ definitionsCommonEventType


creatorRoleDecoder : Decoder (List CreatorRoleItem)
creatorRoleDecoder =
    Decode.list creatorRoleItemDecoder


creatorRoleItemDecoder : Decoder CreatorRoleItem
creatorRoleItemDecoder =
    Decode.succeed CreatorRoleItem
        |> required "@type" creatorRoleAttypeDecoder
        |> required "creator" creatorDecoder
        |> optional "roleName" (Decode.nullable Decode.string) Nothing


eventDecoder : Decoder Event
eventDecoder =
    Decode.succeed Event
        |> required "@type" definitionsCommonEventTypeDecoder
        |> optional "additionalOffering" (Decode.nullable additionalOfferingDecoder) Nothing
        |> optional "doorTime" (Decode.nullable Decode.string) Nothing
        |> optional "duration" (Decode.nullable Decode.int) Nothing
        |> optional "endDate" (Decode.nullable Decode.string) Nothing
        |> optional "eventStatus" (Decode.nullable eventEventStatusDecoder) Nothing
        |> optional "eventType" (Decode.nullable eventTypeDecoder) Nothing
        |> required "identifier" Decode.string
        |> optional "intermission" (Decode.nullable Decode.int) Nothing
        |> optional "location" (Decode.nullable locationDecoder) Nothing
        |> optional "offers" (Decode.nullable offersDecoder) Nothing
        |> optional "performer" (Decode.nullable performanceRoleDecoder) Nothing
        |> optional "previousStartDate" (Decode.nullable Decode.string) Nothing
        |> required "startDate" Decode.string
        |> optional "subtitleLanguage" (Decode.nullable Decode.string) Nothing
        |> optional "url" (Decode.nullable Decode.string) Nothing


offerDecoder : Decoder Offer
offerDecoder =
    Decode.succeed Offer
        |> required "@type" offerAttypeDecoder
        |> optional "availability" (Decode.nullable offerAvailabilityDecoder) Nothing
        |> optional "name" (Decode.nullable Decode.string) Nothing
        |> required "priceSpecification" priceSpecificationDecoder
        |> optional "url" (Decode.nullable Decode.string) Nothing


offeringDecoder : Decoder Offering
offeringDecoder =
    Decode.succeed Offering
        |> required "@type" definitionsCommonEventTypeDecoder
        |> optional "description" (Decode.nullable Decode.string) Nothing
        |> optional "duration" (Decode.nullable Decode.int) Nothing
        |> optional "endDate" (Decode.nullable Decode.string) Nothing
        |> optional "location" (Decode.nullable Decode.string) Nothing
        |> required "name" Decode.string
        |> optional "startDate" (Decode.nullable Decode.string) Nothing


organizationDecoder : Decoder Organization
organizationDecoder =
    Decode.succeed Organization
        |> required "@type" organizationAttypeDecoder
        |> optional "address" (Decode.nullable postalAddressDecoder) Nothing
        |> optional "logo" (Decode.nullable Decode.string) Nothing
        |> required "name" Decode.string


originalWorkDecoder : Decoder OriginalWork
originalWorkDecoder =
    Decode.succeed OriginalWork
        |> required "@type" definitionsCommonCreativeWorkTypeDecoder
        |> optional "author" (Decode.nullable authorDecoder) Nothing
        |> required "name" Decode.string
        |> optional "translator" (Decode.nullable translatorDecoder) Nothing


performanceRoleDecoder : Decoder (List PerformanceRoleItem)
performanceRoleDecoder =
    Decode.list performanceRoleItemDecoder


performanceRoleItemDecoder : Decoder PerformanceRoleItem
performanceRoleItemDecoder =
    Decode.succeed PerformanceRoleItem
        |> required "@type" performanceRoleAttypeDecoder
        |> optional "characterName" (Decode.nullable Decode.string) Nothing
        |> required "performer" performerDecoder


personDecoder : Decoder Person
personDecoder =
    Decode.succeed Person
        |> required "@type" personAttypeDecoder
        |> required "name" Decode.string


personOrOrganizationDecoder : Decoder PersonOrOrganization
personOrOrganizationDecoder =
    Decode.oneOf [ personDecoder |> Decode.map PersonOrOrganizationPe
                 , organizationDecoder |> Decode.map PersonOrOrganizationOr
                 ]


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
        |> required "@type" definitionsCommonCreativeWorkTypeDecoder
        |> optional "abstract" (Decode.nullable Decode.string) Nothing
        |> optional "accessModeSufficient" (Decode.nullable accessModeSufficientDecoder) Nothing
        |> optional "accessibilityHazard" (Decode.nullable accessibilityHazardDecoder) Nothing
        |> optional "accessibilitySummary" (Decode.nullable Decode.string) Nothing
        |> optional "additionalInfo" (Decode.nullable Decode.string) Nothing
        |> optional "audience" (Decode.nullable audienceDecoder) Nothing
        |> optional "creator" (Decode.nullable creatorRoleDecoder) Nothing
        |> optional "description" (Decode.nullable Decode.string) Nothing
        |> required "events" eventsDecoder
        |> optional "funder" (Decode.nullable funderDecoder) Nothing
        |> optional "genre" (Decode.nullable genreDecoder) Nothing
        |> required "identifier" Decode.string
        |> optional "inLanguage" (Decode.nullable Decode.string) Nothing
        |> optional "isBasedOn" (Decode.nullable originalWorkDecoder) Nothing
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
        |> optional "description" (Decode.nullable Decode.string) Nothing
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


additionalOfferingDecoder : Decoder (List Offering)
additionalOfferingDecoder =
    Decode.list offeringDecoder


authorDecoder : Decoder (List Person)
authorDecoder =
    Decode.list personDecoder


offerAvailabilityDecoder : Decoder OfferAvailability
offerAvailabilityDecoder =
    Decode.string |> Decode.andThen (parseOfferAvailability >> Decode.fromResult)


parseOfferAvailability : String -> Result String OfferAvailability
parseOfferAvailability offerAvailability =
    case offerAvailability of
        "InStock" ->
            Ok InStockOffer

        "SoldOut" ->
            Ok SoldOutOffer

        _ ->
            Err <| "Unknown offerAvailability type: " ++ offerAvailability


creatorDecoder : Decoder (List PersonOrOrganization)
creatorDecoder =
    Decode.list personOrOrganizationDecoder


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

        "Preview" ->
            Ok PreviewEventType

        _ ->
            Err <| "Unknown eventTypeItem type: " ++ eventTypeItem


eventsDecoder : Decoder (List Event)
eventsDecoder =
    Decode.list eventDecoder


funderDecoder : Decoder (List Organization)
funderDecoder =
    Decode.list organizationDecoder


genreDecoder : Decoder (List GenreItem)
genreDecoder =
    Decode.list genreItemDecoder


genreItemDecoder : Decoder GenreItem
genreItemDecoder =
    Decode.string |> Decode.andThen (parseGenreItem >> Decode.fromResult)


parseGenreItem : String -> Result String GenreItem
parseGenreItem genreItem =
    case genreItem of
        "audiowalk" ->
            Ok AudiowalkGenre

        "ballett" ->
            Ok BallettGenre

        "digitaltheater" ->
            Ok DigitaltheaterGenre

        "figurentheater" ->
            Ok FigurentheaterGenre

        "game-theater" ->
            Ok GameTheaterGenre

        "hoerspiel" ->
            Ok HoerspielGenre

        "improtheater" ->
            Ok ImprotheaterGenre

        "installation" ->
            Ok InstallationGenre

        "kabarett-comedy" ->
            Ok KabarettComedyGenre

        "kammerkonzert" ->
            Ok KammerkonzertGenre

        "konzert" ->
            Ok KonzertGenre

        "lecture-performance" ->
            Ok LecturePerformanceGenre

        "lesung" ->
            Ok LesungGenre

        "musical" ->
            Ok MusicalGenre

        "musiktheater" ->
            Ok MusiktheaterGenre

        "objekttheater" ->
            Ok ObjekttheaterGenre

        "oper" ->
            Ok OperGenre

        "operette" ->
            Ok OperetteGenre

        "performance" ->
            Ok PerformanceGenre

        "physical-theatre" ->
            Ok PhysicalTheatreGenre

        "podcast" ->
            Ok PodcastGenre

        "puppentheater" ->
            Ok PuppentheaterGenre

        "sinfoniekonzert" ->
            Ok SinfoniekonzertGenre

        "sprechtheater" ->
            Ok SprechtheaterGenre

        "szenische-lesung" ->
            Ok SzenischeLesungGenre

        "szenisches-konzert" ->
            Ok SzenischesKonzertGenre

        "tanz" ->
            Ok TanzGenre

        "theater-im-oeffentlichen-raum" ->
            Ok TheaterImOeffentlichenRaumGenre

        "workshop" ->
            Ok WorkshopGenre

        "zeitgenoessischer-tanz" ->
            Ok ZeitgenoessischerTanzGenre

        _ ->
            Err <| "Unknown genreItem type: " ++ genreItem


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


performerDecoder : Decoder (List PersonOrOrganization)
performerDecoder =
    Decode.list personOrOrganizationDecoder


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


translatorDecoder : Decoder (List PersonOrOrganization)
translatorDecoder =
    Decode.list personOrOrganizationDecoder


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


encodeCreatorRoleAttype : CreatorRoleAttype -> Value
encodeCreatorRoleAttype creatorRoleAttype =
    creatorRoleAttype |> creatorRoleAttypeToString |> Encode.string


creatorRoleAttypeToString : CreatorRoleAttype -> String
creatorRoleAttypeToString creatorRoleAttype =
    case creatorRoleAttype of
        RoleType ->
            "Role"


encodePerformanceRoleAttype : PerformanceRoleAttype -> Value
encodePerformanceRoleAttype performanceRoleAttype =
    performanceRoleAttype |> performanceRoleAttypeToString |> Encode.string


performanceRoleAttypeToString : PerformanceRoleAttype -> String
performanceRoleAttypeToString performanceRoleAttype =
    case performanceRoleAttype of
        PerformanceRoleType ->
            "PerformanceRole"


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


encodeDefinitionsCommonCreativeWorkType : DefinitionsCommonCreativeWorkType -> Value
encodeDefinitionsCommonCreativeWorkType definitionsCommonCreativeWorkType =
    definitionsCommonCreativeWorkType |> definitionsCommonCreativeWorkTypeToString |> Encode.string


definitionsCommonCreativeWorkTypeToString : DefinitionsCommonCreativeWorkType -> String
definitionsCommonCreativeWorkTypeToString definitionsCommonCreativeWorkType =
    case definitionsCommonCreativeWorkType of
        CreativeWorkDefinitions ->
            "CreativeWork"

        PlayDefinitions ->
            "Play"


encodeDefinitionsCommonEventType : DefinitionsCommonEventType -> Value
encodeDefinitionsCommonEventType definitionsCommonEventType =
    definitionsCommonEventType |> definitionsCommonEventTypeToString |> Encode.string


definitionsCommonEventTypeToString : DefinitionsCommonEventType -> String
definitionsCommonEventTypeToString definitionsCommonEventType =
    case definitionsCommonEventType of
        EventDefinitions ->
            "Event"


encodeCreatorRole : List CreatorRoleItem -> Value
encodeCreatorRole creatorRole =
    creatorRole
        |> Encode.list encodeCreatorRoleItem


encodeCreatorRoleItem : CreatorRoleItem -> Value
encodeCreatorRoleItem creatorRoleItem =
    []
        |> Encode.required "@type" creatorRoleItem.atType encodeCreatorRoleAttype
        |> Encode.required "creator" creatorRoleItem.creator encodeCreator
        |> Encode.optional "roleName" creatorRoleItem.roleName Encode.string
        |> Encode.object


encodeEvent : Event -> Value
encodeEvent event =
    []
        |> Encode.required "@type" event.atType encodeDefinitionsCommonEventType
        |> Encode.optional "additionalOffering" event.additionalOffering encodeAdditionalOffering
        |> Encode.optional "doorTime" event.doorTime Encode.string
        |> Encode.optional "duration" event.duration Encode.int
        |> Encode.optional "endDate" event.endDate Encode.string
        |> Encode.optional "eventStatus" event.eventStatus encodeEventEventStatus
        |> Encode.optional "eventType" event.eventType encodeEventType
        |> Encode.required "identifier" event.identifier Encode.string
        |> Encode.optional "intermission" event.intermission Encode.int
        |> Encode.optional "location" event.location encodeLocation
        |> Encode.optional "offers" event.offers encodeOffers
        |> Encode.optional "performer" event.performer encodePerformanceRole
        |> Encode.optional "previousStartDate" event.previousStartDate Encode.string
        |> Encode.required "startDate" event.startDate Encode.string
        |> Encode.optional "subtitleLanguage" event.subtitleLanguage Encode.string
        |> Encode.optional "url" event.url Encode.string
        |> Encode.object


encodeOffer : Offer -> Value
encodeOffer offer =
    []
        |> Encode.required "@type" offer.atType encodeOfferAttype
        |> Encode.optional "availability" offer.availability encodeOfferAvailability
        |> Encode.optional "name" offer.name Encode.string
        |> Encode.required "priceSpecification" offer.priceSpecification encodePriceSpecification
        |> Encode.optional "url" offer.url Encode.string
        |> Encode.object


encodeOffering : Offering -> Value
encodeOffering offering =
    []
        |> Encode.required "@type" offering.atType encodeDefinitionsCommonEventType
        |> Encode.optional "description" offering.description Encode.string
        |> Encode.optional "duration" offering.duration Encode.int
        |> Encode.optional "endDate" offering.endDate Encode.string
        |> Encode.optional "location" offering.location Encode.string
        |> Encode.required "name" offering.name Encode.string
        |> Encode.optional "startDate" offering.startDate Encode.string
        |> Encode.object


encodeOrganization : Organization -> Value
encodeOrganization organization =
    []
        |> Encode.required "@type" organization.atType encodeOrganizationAttype
        |> Encode.optional "address" organization.address encodePostalAddress
        |> Encode.optional "logo" organization.logo Encode.string
        |> Encode.required "name" organization.name Encode.string
        |> Encode.object


encodeOriginalWork : OriginalWork -> Value
encodeOriginalWork originalWork =
    []
        |> Encode.required "@type" originalWork.atType encodeDefinitionsCommonCreativeWorkType
        |> Encode.optional "author" originalWork.author encodeAuthor
        |> Encode.required "name" originalWork.name Encode.string
        |> Encode.optional "translator" originalWork.translator encodeTranslator
        |> Encode.object


encodePerformanceRole : List PerformanceRoleItem -> Value
encodePerformanceRole performanceRole =
    performanceRole
        |> Encode.list encodePerformanceRoleItem


encodePerformanceRoleItem : PerformanceRoleItem -> Value
encodePerformanceRoleItem performanceRoleItem =
    []
        |> Encode.required "@type" performanceRoleItem.atType encodePerformanceRoleAttype
        |> Encode.optional "characterName" performanceRoleItem.characterName Encode.string
        |> Encode.required "performer" performanceRoleItem.performer encodePerformer
        |> Encode.object


encodePerson : Person -> Value
encodePerson person =
    []
        |> Encode.required "@type" person.atType encodePersonAttype
        |> Encode.required "name" person.name Encode.string
        |> Encode.object


encodePersonOrOrganization : PersonOrOrganization -> Value
encodePersonOrOrganization personOrOrganization =
    case personOrOrganization of
        PersonOrOrganizationPe person ->
            encodePerson person

        PersonOrOrganizationOr organization ->
            encodeOrganization organization


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
        |> Encode.required "@type" production.atType encodeDefinitionsCommonCreativeWorkType
        |> Encode.optional "abstract" production.abstract Encode.string
        |> Encode.optional "accessModeSufficient" production.accessModeSufficient encodeAccessModeSufficient
        |> Encode.optional "accessibilityHazard" production.accessibilityHazard encodeAccessibilityHazard
        |> Encode.optional "accessibilitySummary" production.accessibilitySummary Encode.string
        |> Encode.optional "additionalInfo" production.additionalInfo Encode.string
        |> Encode.optional "audience" production.audience encodeAudience
        |> Encode.optional "creator" production.creator encodeCreatorRole
        |> Encode.optional "description" production.description Encode.string
        |> Encode.required "events" production.events encodeEvents
        |> Encode.optional "funder" production.funder encodeFunder
        |> Encode.optional "genre" production.genre encodeGenre
        |> Encode.required "identifier" production.identifier Encode.string
        |> Encode.optional "inLanguage" production.inLanguage Encode.string
        |> Encode.optional "isBasedOn" production.isBasedOn encodeOriginalWork
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
        |> Encode.optional "description" virtualLocation.description Encode.string
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


encodeAdditionalOffering : List Offering -> Value
encodeAdditionalOffering additionalOffering =
    additionalOffering
        |> Encode.list encodeOffering


encodeAuthor : List Person -> Value
encodeAuthor author =
    author
        |> Encode.list encodePerson


encodeOfferAvailability : OfferAvailability -> Value
encodeOfferAvailability offerAvailability =
    offerAvailability |> offerAvailabilityToString |> Encode.string


offerAvailabilityToString : OfferAvailability -> String
offerAvailabilityToString offerAvailability =
    case offerAvailability of
        InStockOffer ->
            "InStock"

        SoldOutOffer ->
            "SoldOut"


encodeCreator : List PersonOrOrganization -> Value
encodeCreator creator =
    creator
        |> Encode.list encodePersonOrOrganization


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

        PreviewEventType ->
            "Preview"


encodeEvents : List Event -> Value
encodeEvents events =
    events
        |> Encode.list encodeEvent


encodeFunder : List Organization -> Value
encodeFunder funder =
    funder
        |> Encode.list encodeOrganization


encodeGenre : List GenreItem -> Value
encodeGenre genre =
    genre
        |> Encode.list encodeGenreItem


encodeGenreItem : GenreItem -> Value
encodeGenreItem genreItem =
    genreItem |> genreItemToString |> Encode.string


genreItemToString : GenreItem -> String
genreItemToString genreItem =
    case genreItem of
        AudiowalkGenre ->
            "audiowalk"

        BallettGenre ->
            "ballett"

        DigitaltheaterGenre ->
            "digitaltheater"

        FigurentheaterGenre ->
            "figurentheater"

        GameTheaterGenre ->
            "game-theater"

        HoerspielGenre ->
            "hoerspiel"

        ImprotheaterGenre ->
            "improtheater"

        InstallationGenre ->
            "installation"

        KabarettComedyGenre ->
            "kabarett-comedy"

        KammerkonzertGenre ->
            "kammerkonzert"

        KonzertGenre ->
            "konzert"

        LecturePerformanceGenre ->
            "lecture-performance"

        LesungGenre ->
            "lesung"

        MusicalGenre ->
            "musical"

        MusiktheaterGenre ->
            "musiktheater"

        ObjekttheaterGenre ->
            "objekttheater"

        OperGenre ->
            "oper"

        OperetteGenre ->
            "operette"

        PerformanceGenre ->
            "performance"

        PhysicalTheatreGenre ->
            "physical-theatre"

        PodcastGenre ->
            "podcast"

        PuppentheaterGenre ->
            "puppentheater"

        SinfoniekonzertGenre ->
            "sinfoniekonzert"

        SprechtheaterGenre ->
            "sprechtheater"

        SzenischeLesungGenre ->
            "szenische-lesung"

        SzenischesKonzertGenre ->
            "szenisches-konzert"

        TanzGenre ->
            "tanz"

        TheaterImOeffentlichenRaumGenre ->
            "theater-im-oeffentlichen-raum"

        WorkshopGenre ->
            "workshop"

        ZeitgenoessischerTanzGenre ->
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


encodePerformer : List PersonOrOrganization -> Value
encodePerformer performer =
    performer
        |> Encode.list encodePersonOrOrganization


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


encodeTranslator : List PersonOrOrganization -> Value
encodeTranslator translator =
    translator
        |> Encode.list encodePersonOrOrganization


encodeVersion : Version -> Value
encodeVersion version =
    version |> versionToString |> Encode.string


versionToString : Version -> String
versionToString version =
    case version of
        V2 ->
            "v2"
