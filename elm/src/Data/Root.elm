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


type PriceSpecificationAttype
    = PriceSpecificationType


type OffersAttype
    = OfferType


type AddressLocationAttype
    = PlaceType


type OrganizationAttype
    = OrganizationType


type EventsAttype
    = EventType


type PerformerPersonAttype
    = PerformerPersonType


type VirtualLocationAttype
    = VirtualLocationType


type ProductionsAttype
    = CreativeWorkType
    | PlayType


type AddressAttype
    = PostalAddressType


type PerformerAttype
    = PerformanceRoleType


type CreatorAttype
    = CreatorRoleType


type CreatorPersonAttype
    = CreatorPersonType


type alias AddressLocation =
    { atType : AddressLocationAttype
    , address : Address
    , latitude : Maybe Float
    , longitude : Maybe Float
    , name : Maybe String
    , wheelChairPlaces : Maybe WheelChairPlaces
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


type alias Address =
    { atType : AddressAttype
    , addressLocality : Maybe String
    , postalCode : Maybe String
    , streetAddress : Maybe String
    }


type alias Creator =
    { atType : CreatorPersonAttype
    , name : String
    }


type alias CreatorItem =
    { atType : CreatorAttype
    , creator : Creator
    , roleName : Maybe String
    }


type alias Event =
    { atType : EventsAttype
    , duration : Maybe Int
    , endDate : Maybe String
    , eventStatus : Maybe EventsEventStatus
    , inLanguage : Maybe String
    , location : Maybe (List LocationItem)
    , offers : Maybe (List Offer)
    , performer : Maybe (List PerformerItem)
    , previousStartDate : Maybe String
    , startDate : String
    , url : Maybe String
    }


type EventsEventStatus
    = EventScheduledEvents
    | EventCancelledEvents
    | EventMovedOnlineEvents
    | EventPostponedEvents
    | EventRescheduledEvents


type ProductionsGenre
    = AudiowalkProductions
    | BallettProductions
    | DigitaltheaterProductions
    | FigurentheaterProductions
    | GameTheaterProductions
    | HoerspielProductions
    | ImprotheaterProductions
    | InstallationProductions
    | KabarettComedyProductions
    | KammerkonzertProductions
    | KonzertProductions
    | LecturePerformanceProductions
    | LesungProductions
    | MusicalProductions
    | MusiktheaterProductions
    | ObjekttheaterProductions
    | OperProductions
    | OperetteProductions
    | PerformanceProductions
    | PhysicalTheatreProductions
    | PodcastProductions
    | PuppentheaterProductions
    | SinfoniekonzertProductions
    | SprechtheaterProductions
    | SzenischeLesungProductions
    | SzenischesKonzertProductions
    | TanzProductions
    | TheaterImOeffentlichenRaumProductions
    | WorkshopProductions
    | ZeitgenoessischerTanzProductions


type LocationItem
    = Physical AddressLocation
    | Virtual VirtualLocation


type alias Offer =
    { atType : OffersAttype
    , name : Maybe String
    , priceSpecification : PriceSpecification
    , url : Maybe String
    }


type alias Organization =
    { atType : OrganizationAttype
    , address : Maybe Address
    , name : String
    }


type alias Performer =
    { atType : PerformerPersonAttype
    , name : String
    }


type alias PerformerItem =
    { atType : PerformerAttype
    , characterName : Maybe String
    , performer : Performer
    }


type alias PriceSpecification =
    { atType : PriceSpecificationAttype
    , maxPrice : Maybe Float
    , minPrice : Float
    , priceCurrency : String
    }


type alias Production =
    { atType : ProductionsAttype
    , abstract : Maybe String
    , accessModeSufficient : Maybe (List AccessModeSufficientItem)
    , accessibilityHazard : Maybe (List AccessibilityHazardItem)
    , accessibilitySummary : Maybe String
    , additionalInfo : Maybe String
    , creator : Maybe (List CreatorItem)
    , description : Maybe String
    , events : List Event
    , genre : Maybe ProductionsGenre
    , name : String
    , subtitle : Maybe String
    }


type Version
    = V1


type alias WheelChairPlaces =
    { count : Int
    , hasSpaceForAssistant : Maybe Bool
    , wheelchairUserCapacity : Maybe Int
    }


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


offersAttypeDecoder : Decoder OffersAttype
offersAttypeDecoder =
    Decode.string |> Decode.andThen (parseOffersAttype >> Decode.fromResult)


parseOffersAttype : String -> Result String OffersAttype
parseOffersAttype offersAttype =
    case offersAttype of
        "Offer" ->
            Ok OfferType

        _ ->
            Err <| "Unknown offersAttype type: " ++ offersAttype


addressLocationAttypeDecoder : Decoder AddressLocationAttype
addressLocationAttypeDecoder =
    Decode.string |> Decode.andThen (parseAddressLocationAttype >> Decode.fromResult)


parseAddressLocationAttype : String -> Result String AddressLocationAttype
parseAddressLocationAttype addressLocationAttype =
    case addressLocationAttype of
        "Place" ->
            Ok PlaceType

        _ ->
            Err <| "Unknown addressLocationAttype type: " ++ addressLocationAttype


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


eventsAttypeDecoder : Decoder EventsAttype
eventsAttypeDecoder =
    Decode.string |> Decode.andThen (parseEventsAttype >> Decode.fromResult)


parseEventsAttype : String -> Result String EventsAttype
parseEventsAttype eventsAttype =
    case eventsAttype of
        "Event" ->
            Ok EventType

        _ ->
            Err <| "Unknown eventsAttype type: " ++ eventsAttype


performerPersonAttypeDecoder : Decoder PerformerPersonAttype
performerPersonAttypeDecoder =
    Decode.string |> Decode.andThen (parsePerformerPersonAttype >> Decode.fromResult)


parsePerformerPersonAttype : String -> Result String PerformerPersonAttype
parsePerformerPersonAttype performerAttype =
    case performerAttype of
        "Person" ->
            Ok PerformerPersonType

        _ ->
            Err <| "Unknown performerAttype type: " ++ performerAttype


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


productionsAttypeDecoder : Decoder ProductionsAttype
productionsAttypeDecoder =
    Decode.string |> Decode.andThen (parseProductionsAttype >> Decode.fromResult)


parseProductionsAttype : String -> Result String ProductionsAttype
parseProductionsAttype productionsAttype =
    case productionsAttype of
        "CreativeWork" ->
            Ok CreativeWorkType

        "Play" ->
            Ok PlayType

        _ ->
            Err <| "Unknown productionsAttype type: " ++ productionsAttype


addressAttypeDecoder : Decoder AddressAttype
addressAttypeDecoder =
    Decode.string |> Decode.andThen (parseAddressAttype >> Decode.fromResult)


parseAddressAttype : String -> Result String AddressAttype
parseAddressAttype addressAttype =
    case addressAttype of
        "PostalAddress" ->
            Ok PostalAddressType

        _ ->
            Err <| "Unknown addressAttype type: " ++ addressAttype


performerAttypeDecoder : Decoder PerformerAttype
performerAttypeDecoder =
    Decode.string |> Decode.andThen (parsePerformerAttype >> Decode.fromResult)


parsePerformerAttype : String -> Result String PerformerAttype
parsePerformerAttype performerAttype =
    case performerAttype of
        "PerformanceRole" ->
            Ok PerformanceRoleType

        _ ->
            Err <| "Unknown performerAttype type: " ++ performerAttype


creatorAttypeDecoder : Decoder CreatorAttype
creatorAttypeDecoder =
    Decode.string |> Decode.andThen (parseCreatorAttype >> Decode.fromResult)


parseCreatorAttype : String -> Result String CreatorAttype
parseCreatorAttype creatorAttype =
    case creatorAttype of
        "Role" ->
            Ok CreatorRoleType

        _ ->
            Err <| "Unknown creatorAttype type: " ++ creatorAttype


creatorPersonAttypeDecoder : Decoder CreatorPersonAttype
creatorPersonAttypeDecoder =
    Decode.string |> Decode.andThen (parseCreatorPersonAttype >> Decode.fromResult)


parseCreatorPersonAttype : String -> Result String CreatorPersonAttype
parseCreatorPersonAttype creatorAttype =
    case creatorAttype of
        "Person" ->
            Ok CreatorPersonType

        _ ->
            Err <| "Unknown creatorAttype type: " ++ creatorAttype


addressLocationDecoder : Decoder AddressLocation
addressLocationDecoder =
    Decode.succeed AddressLocation
        |> required "@type" addressLocationAttypeDecoder
        |> required "address" addressDecoder
        |> optional "latitude" (Decode.nullable Decode.float) Nothing
        |> optional "longitude" (Decode.nullable Decode.float) Nothing
        |> optional "name" (Decode.nullable Decode.string) Nothing
        |> optional "wheelChairPlaces" (Decode.nullable wheelChairPlacesDecoder) Nothing


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


addressDecoder : Decoder Address
addressDecoder =
    Decode.succeed Address
        |> required "@type" addressAttypeDecoder
        |> optional "addressLocality" (Decode.nullable Decode.string) Nothing
        |> optional "postalCode" (Decode.nullable Decode.string) Nothing
        |> optional "streetAddress" (Decode.nullable Decode.string) Nothing


creatorPersonDecoder : Decoder Creator
creatorPersonDecoder =
    Decode.succeed Creator
        |> required "@type" creatorPersonAttypeDecoder
        |> required "name" Decode.string


creatorDecoder : Decoder (List CreatorItem)
creatorDecoder =
    Decode.list creatorItemDecoder


creatorItemDecoder : Decoder CreatorItem
creatorItemDecoder =
    Decode.succeed CreatorItem
        |> required "@type" creatorAttypeDecoder
        |> required "creator" creatorPersonDecoder
        |> optional "roleName" (Decode.nullable Decode.string) Nothing


eventDecoder : Decoder Event
eventDecoder =
    Decode.succeed Event
        |> required "@type" eventsAttypeDecoder
        |> optional "duration" (Decode.nullable Decode.int) Nothing
        |> optional "endDate" (Decode.nullable Decode.string) Nothing
        |> optional "eventStatus" (Decode.nullable eventsEventStatusDecoder) Nothing
        |> optional "inLanguage" (Decode.nullable Decode.string) Nothing
        |> optional "location" (Decode.nullable locationDecoder) Nothing
        |> optional "offers" (Decode.nullable offersDecoder) Nothing
        |> optional "performer" (Decode.nullable performerDecoder) Nothing
        |> optional "previousStartDate" (Decode.nullable Decode.string) Nothing
        |> required "startDate" Decode.string
        |> optional "url" (Decode.nullable Decode.string) Nothing


eventsEventStatusDecoder : Decoder EventsEventStatus
eventsEventStatusDecoder =
    Decode.string |> Decode.andThen (parseEventsEventStatus >> Decode.fromResult)


parseEventsEventStatus : String -> Result String EventsEventStatus
parseEventsEventStatus eventsEventStatus =
    case eventsEventStatus of
        "EventScheduled" ->
            Ok EventScheduledEvents

        "EventCancelled" ->
            Ok EventCancelledEvents

        "EventMovedOnline" ->
            Ok EventMovedOnlineEvents

        "EventPostponed" ->
            Ok EventPostponedEvents

        "EventRescheduled" ->
            Ok EventRescheduledEvents

        _ ->
            Err <| "Unknown eventsEventStatus type: " ++ eventsEventStatus


eventsDecoder : Decoder (List Event)
eventsDecoder =
    Decode.list eventDecoder


productionsGenreDecoder : Decoder ProductionsGenre
productionsGenreDecoder =
    Decode.string |> Decode.andThen (parseProductionsGenre >> Decode.fromResult)


parseProductionsGenre : String -> Result String ProductionsGenre
parseProductionsGenre productionsGenre =
    case productionsGenre of
        "audiowalk" ->
            Ok AudiowalkProductions

        "ballett" ->
            Ok BallettProductions

        "digitaltheater" ->
            Ok DigitaltheaterProductions

        "figurentheater" ->
            Ok FigurentheaterProductions

        "game-theater" ->
            Ok GameTheaterProductions

        "hoerspiel" ->
            Ok HoerspielProductions

        "improtheater" ->
            Ok ImprotheaterProductions

        "installation" ->
            Ok InstallationProductions

        "kabarett-comedy" ->
            Ok KabarettComedyProductions

        "kammerkonzert" ->
            Ok KammerkonzertProductions

        "konzert" ->
            Ok KonzertProductions

        "lecture-performance" ->
            Ok LecturePerformanceProductions

        "lesung" ->
            Ok LesungProductions

        "musical" ->
            Ok MusicalProductions

        "musiktheater" ->
            Ok MusiktheaterProductions

        "objekttheater" ->
            Ok ObjekttheaterProductions

        "oper" ->
            Ok OperProductions

        "operette" ->
            Ok OperetteProductions

        "performance" ->
            Ok PerformanceProductions

        "physical-theatre" ->
            Ok PhysicalTheatreProductions

        "podcast" ->
            Ok PodcastProductions

        "puppentheater" ->
            Ok PuppentheaterProductions

        "sinfoniekonzert" ->
            Ok SinfoniekonzertProductions

        "sprechtheater" ->
            Ok SprechtheaterProductions

        "szenische-lesung" ->
            Ok SzenischeLesungProductions

        "szenisches-konzert" ->
            Ok SzenischesKonzertProductions

        "tanz" ->
            Ok TanzProductions

        "theater-im-oeffentlichen-raum" ->
            Ok TheaterImOeffentlichenRaumProductions

        "workshop" ->
            Ok WorkshopProductions

        "zeitgenoessischer-tanz" ->
            Ok ZeitgenoessischerTanzProductions

        _ ->
            Err <| "Unknown productionsGenre type: " ++ productionsGenre


locationDecoder : Decoder (List LocationItem)
locationDecoder =
    Decode.list locationItemDecoder


locationItemDecoder : Decoder LocationItem
locationItemDecoder =
    Decode.oneOf
        [ Decode.map Physical addressLocationDecoder
        , Decode.map Virtual virtualLocationDecoder
        ]


offerDecoder : Decoder Offer
offerDecoder =
    Decode.succeed Offer
        |> required "@type" offersAttypeDecoder
        |> optional "name" (Decode.nullable Decode.string) Nothing
        |> required "priceSpecification" priceSpecificationDecoder
        |> optional "url" (Decode.nullable Decode.string) Nothing


offersDecoder : Decoder (List Offer)
offersDecoder =
    Decode.list offerDecoder


organizationDecoder : Decoder Organization
organizationDecoder =
    Decode.succeed Organization
        |> required "@type" organizationAttypeDecoder
        |> optional "address" (Decode.nullable addressDecoder) Nothing
        |> required "name" Decode.string


performerDecoder : Decoder (List PerformerItem)
performerDecoder =
    Decode.list performerItemDecoder


performerPersonDecoder : Decoder Performer
performerPersonDecoder =
    Decode.succeed Performer
        |> required "@type" performerPersonAttypeDecoder
        |> required "name" Decode.string


performerItemDecoder : Decoder PerformerItem
performerItemDecoder =
    Decode.succeed PerformerItem
        |> required "@type" performerAttypeDecoder
        |> optional "characterName" (Decode.nullable Decode.string) Nothing
        |> required "performer" performerPersonDecoder


priceSpecificationDecoder : Decoder PriceSpecification
priceSpecificationDecoder =
    Decode.succeed PriceSpecification
        |> required "@type" priceSpecificationAttypeDecoder
        |> optional "maxPrice" (Decode.nullable Decode.float) Nothing
        |> required "minPrice" Decode.float
        |> required "priceCurrency" Decode.string


productionDecoder : Decoder Production
productionDecoder =
    Decode.succeed Production
        |> required "@type" productionsAttypeDecoder
        |> optional "abstract" (Decode.nullable Decode.string) Nothing
        |> optional "accessModeSufficient" (Decode.nullable accessModeSufficientDecoder) Nothing
        |> optional "accessibilityHazard" (Decode.nullable accessibilityHazardDecoder) Nothing
        |> optional "accessibilitySummary" (Decode.nullable Decode.string) Nothing
        |> optional "additionalInfo" (Decode.nullable Decode.string) Nothing
        |> optional "creator" (Decode.nullable creatorDecoder) Nothing
        |> optional "description" (Decode.nullable Decode.string) Nothing
        |> required "events" eventsDecoder
        |> optional "genre" (Decode.nullable productionsGenreDecoder) Nothing
        |> required "name" Decode.string
        |> optional "subtitle" (Decode.nullable Decode.string) Nothing


productionsDecoder : Decoder (List Production)
productionsDecoder =
    Decode.list productionDecoder


versionDecoder : Decoder Version
versionDecoder =
    Decode.string |> Decode.andThen (parseVersion >> Decode.fromResult)


parseVersion : String -> Result String Version
parseVersion version =
    case version of
        "v1" ->
            Ok V1

        _ ->
            Err <| "Unknown version type: " ++ version


wheelChairPlacesDecoder : Decoder WheelChairPlaces
wheelChairPlacesDecoder =
    Decode.succeed WheelChairPlaces
        |> required "count" Decode.int
        |> optional "hasSpaceForAssistant" (Decode.nullable Decode.bool) Nothing
        |> optional "wheelchairUserCapacity" (Decode.nullable Decode.int) Nothing


encodeAtContext : AtContext -> Value
encodeAtContext atContext =
    atContext |> atContextToString |> Encode.string


atContextToString : AtContext -> String
atContextToString atContext =
    case atContext of
        HttpsColonSlashSlashschemaDotorg ->
            "https://schema.org"


encodePriceSpecificationAttype : PriceSpecificationAttype -> Value
encodePriceSpecificationAttype priceSpecificationAttype =
    priceSpecificationAttype |> priceSpecificationAttypeToString |> Encode.string


priceSpecificationAttypeToString : PriceSpecificationAttype -> String
priceSpecificationAttypeToString priceSpecificationAttype =
    case priceSpecificationAttype of
        PriceSpecificationType ->
            "PriceSpecification"


encodeOffersAttype : OffersAttype -> Value
encodeOffersAttype offersAttype =
    offersAttype |> offersAttypeToString |> Encode.string


offersAttypeToString : OffersAttype -> String
offersAttypeToString offersAttype =
    case offersAttype of
        OfferType ->
            "Offer"


encodeAddressLocationAttype : AddressLocationAttype -> Value
encodeAddressLocationAttype addressLocationAttype =
    addressLocationAttype |> addressLocationAttypeToString |> Encode.string


addressLocationAttypeToString : AddressLocationAttype -> String
addressLocationAttypeToString addressLocationAttype =
    case addressLocationAttype of
        PlaceType ->
            "Place"


encodeOrganizationAttype : OrganizationAttype -> Value
encodeOrganizationAttype organizationAttype =
    organizationAttype |> organizationAttypeToString |> Encode.string


organizationAttypeToString : OrganizationAttype -> String
organizationAttypeToString organizationAttype =
    case organizationAttype of
        OrganizationType ->
            "Organization"


encodeEventsAttype : EventsAttype -> Value
encodeEventsAttype eventsAttype =
    eventsAttype |> eventsAttypeToString |> Encode.string


eventsAttypeToString : EventsAttype -> String
eventsAttypeToString eventsAttype =
    case eventsAttype of
        EventType ->
            "Event"


encodePerformerPersonAttype : PerformerPersonAttype -> Value
encodePerformerPersonAttype performerAttype =
    performerAttype |> performerPersonAttypeToString |> Encode.string


performerPersonAttypeToString : PerformerPersonAttype -> String
performerPersonAttypeToString performerAttype =
    case performerAttype of
        PerformerPersonType ->
            "Person"


encodeVirtualLocationAttype : VirtualLocationAttype -> Value
encodeVirtualLocationAttype virtualLocationAttype =
    virtualLocationAttype |> virtualLocationAttypeToString |> Encode.string


virtualLocationAttypeToString : VirtualLocationAttype -> String
virtualLocationAttypeToString virtualLocationAttype =
    case virtualLocationAttype of
        VirtualLocationType ->
            "VirtualLocation"


encodeProductionsAttype : ProductionsAttype -> Value
encodeProductionsAttype productionsAttype =
    productionsAttype |> productionsAttypeToString |> Encode.string


productionsAttypeToString : ProductionsAttype -> String
productionsAttypeToString productionsAttype =
    case productionsAttype of
        CreativeWorkType ->
            "CreativeWork"

        PlayType ->
            "Play"


encodeAddressAttype : AddressAttype -> Value
encodeAddressAttype addressAttype =
    addressAttype |> addressAttypeToString |> Encode.string


addressAttypeToString : AddressAttype -> String
addressAttypeToString addressAttype =
    case addressAttype of
        PostalAddressType ->
            "PostalAddress"


encodePerformerAttype : PerformerAttype -> Value
encodePerformerAttype performerAttype =
    performerAttype |> performerAttypeToString |> Encode.string


performerAttypeToString : PerformerAttype -> String
performerAttypeToString performerAttype =
    case performerAttype of
        PerformanceRoleType ->
            "PerformanceRole"


encodeCreatorAttype : CreatorAttype -> Value
encodeCreatorAttype creatorAttype =
    creatorAttype |> creatorAttypeToString |> Encode.string


creatorAttypeToString : CreatorAttype -> String
creatorAttypeToString creatorAttype =
    case creatorAttype of
        CreatorRoleType ->
            "Role"


encodeCreatorPersonAttype : CreatorPersonAttype -> Value
encodeCreatorPersonAttype creatorPersonAttype =
    creatorPersonAttype |> creatorPersonAttypeToString |> Encode.string


creatorPersonAttypeToString : CreatorPersonAttype -> String
creatorPersonAttypeToString creatorAttype =
    case creatorAttype of
        CreatorPersonType ->
            "Person"


encodeAddressLocation : AddressLocation -> Value
encodeAddressLocation addressLocation =
    []
        |> Encode.required "@type" addressLocation.atType encodeAddressLocationAttype
        |> Encode.required "address" addressLocation.address encodeAddress
        |> Encode.optional "latitude" addressLocation.latitude Encode.float
        |> Encode.optional "longitude" addressLocation.longitude Encode.float
        |> Encode.optional "name" addressLocation.name Encode.string
        |> Encode.optional "wheelChairPlaces" addressLocation.wheelChairPlaces encodeWheelChairPlaces
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


encodeAddress : Address -> Value
encodeAddress address =
    []
        |> Encode.required "@type" address.atType encodeAddressAttype
        |> Encode.optional "addressLocality" address.addressLocality Encode.string
        |> Encode.optional "postalCode" address.postalCode Encode.string
        |> Encode.optional "streetAddress" address.streetAddress Encode.string
        |> Encode.object


encodeCreatorPerson : Creator -> Value
encodeCreatorPerson creator =
    []
        |> Encode.required "@type" creator.atType encodeCreatorPersonAttype
        |> Encode.required "name" creator.name Encode.string
        |> Encode.object


encodeCreator : List CreatorItem -> Value
encodeCreator creator =
    creator
        |> Encode.list encodeCreatorItem


encodeCreatorItem : CreatorItem -> Value
encodeCreatorItem creatorItem =
    []
        |> Encode.required "@type" creatorItem.atType encodeCreatorAttype
        |> Encode.required "creator" creatorItem.creator encodeCreatorPerson
        |> Encode.optional "roleName" creatorItem.roleName Encode.string
        |> Encode.object


encodeEvent : Event -> Value
encodeEvent event =
    []
        |> Encode.required "@type" event.atType encodeEventsAttype
        |> Encode.optional "duration" event.duration Encode.int
        |> Encode.optional "endDate" event.endDate Encode.string
        |> Encode.optional "eventStatus" event.eventStatus encodeEventsEventStatus
        |> Encode.optional "inLanguage" event.inLanguage Encode.string
        |> Encode.optional "location" event.location encodeLocation
        |> Encode.optional "offers" event.offers encodeOffers
        |> Encode.optional "performer" event.performer encodePerformer
        |> Encode.optional "previousStartDate" event.previousStartDate Encode.string
        |> Encode.required "startDate" event.startDate Encode.string
        |> Encode.optional "url" event.url Encode.string
        |> Encode.object


encodeEventsEventStatus : EventsEventStatus -> Value
encodeEventsEventStatus eventsEventStatus =
    eventsEventStatus |> eventsEventStatusToString |> Encode.string


eventsEventStatusToString : EventsEventStatus -> String
eventsEventStatusToString eventsEventStatus =
    case eventsEventStatus of
        EventScheduledEvents ->
            "EventScheduled"

        EventCancelledEvents ->
            "EventCancelled"

        EventMovedOnlineEvents ->
            "EventMovedOnline"

        EventPostponedEvents ->
            "EventPostponed"

        EventRescheduledEvents ->
            "EventRescheduled"


encodeEvents : List Event -> Value
encodeEvents events =
    events
        |> Encode.list encodeEvent


encodeProductionsGenre : ProductionsGenre -> Value
encodeProductionsGenre productionsGenre =
    productionsGenre |> productionsGenreToString |> Encode.string


productionsGenreToString : ProductionsGenre -> String
productionsGenreToString productionsGenre =
    case productionsGenre of
        AudiowalkProductions ->
            "audiowalk"

        BallettProductions ->
            "ballett"

        DigitaltheaterProductions ->
            "digitaltheater"

        FigurentheaterProductions ->
            "figurentheater"

        GameTheaterProductions ->
            "game-theater"

        HoerspielProductions ->
            "hoerspiel"

        ImprotheaterProductions ->
            "improtheater"

        InstallationProductions ->
            "installation"

        KabarettComedyProductions ->
            "kabarett-comedy"

        KammerkonzertProductions ->
            "kammerkonzert"

        KonzertProductions ->
            "konzert"

        LecturePerformanceProductions ->
            "lecture-performance"

        LesungProductions ->
            "lesung"

        MusicalProductions ->
            "musical"

        MusiktheaterProductions ->
            "musiktheater"

        ObjekttheaterProductions ->
            "objekttheater"

        OperProductions ->
            "oper"

        OperetteProductions ->
            "operette"

        PerformanceProductions ->
            "performance"

        PhysicalTheatreProductions ->
            "physical-theatre"

        PodcastProductions ->
            "podcast"

        PuppentheaterProductions ->
            "puppentheater"

        SinfoniekonzertProductions ->
            "sinfoniekonzert"

        SprechtheaterProductions ->
            "sprechtheater"

        SzenischeLesungProductions ->
            "szenische-lesung"

        SzenischesKonzertProductions ->
            "szenisches-konzert"

        TanzProductions ->
            "tanz"

        TheaterImOeffentlichenRaumProductions ->
            "theater-im-oeffentlichen-raum"

        WorkshopProductions ->
            "workshop"

        ZeitgenoessischerTanzProductions ->
            "zeitgenoessischer-tanz"


encodeLocation : List LocationItem -> Value
encodeLocation location =
    location
        |> Encode.list encodeLocationItem


encodeLocationItem : LocationItem -> Value
encodeLocationItem locationItem =
    case locationItem of
        Physical address ->
            encodeAddressLocation address

        Virtual virtual ->
            encodeVirtualLocation virtual


encodeOffer : Offer -> Value
encodeOffer offer =
    []
        |> Encode.required "@type" offer.atType encodeOffersAttype
        |> Encode.optional "name" offer.name Encode.string
        |> Encode.required "priceSpecification" offer.priceSpecification encodePriceSpecification
        |> Encode.optional "url" offer.url Encode.string
        |> Encode.object


encodeOffers : List Offer -> Value
encodeOffers offers =
    offers
        |> Encode.list encodeOffer


encodeOrganization : Organization -> Value
encodeOrganization organization =
    []
        |> Encode.required "@type" organization.atType encodeOrganizationAttype
        |> Encode.optional "address" organization.address encodeAddress
        |> Encode.required "name" organization.name Encode.string
        |> Encode.object


encodePerformer : List PerformerItem -> Value
encodePerformer performer =
    performer
        |> Encode.list encodePerformerItem


encodePerformerPerson : Performer -> Value
encodePerformerPerson performer =
    []
        |> Encode.required "@type" performer.atType encodePerformerPersonAttype
        |> Encode.required "name" performer.name Encode.string
        |> Encode.object


encodePerformerItem : PerformerItem -> Value
encodePerformerItem performerItem =
    []
        |> Encode.required "@type" performerItem.atType encodePerformerAttype
        |> Encode.optional "characterName" performerItem.characterName Encode.string
        |> Encode.required "performer" performerItem.performer encodePerformerPerson
        |> Encode.object


encodePriceSpecification : PriceSpecification -> Value
encodePriceSpecification priceSpecification =
    []
        |> Encode.required "@type" priceSpecification.atType encodePriceSpecificationAttype
        |> Encode.optional "maxPrice" priceSpecification.maxPrice Encode.float
        |> Encode.required "minPrice" priceSpecification.minPrice Encode.float
        |> Encode.required "priceCurrency" priceSpecification.priceCurrency Encode.string
        |> Encode.object


encodeProduction : Production -> Value
encodeProduction production =
    []
        |> Encode.required "@type" production.atType encodeProductionsAttype
        |> Encode.optional "abstract" production.abstract Encode.string
        |> Encode.optional "accessModeSufficient" production.accessModeSufficient encodeAccessModeSufficient
        |> Encode.optional "accessibilityHazard" production.accessibilityHazard encodeAccessibilityHazard
        |> Encode.optional "accessibilitySummary" production.accessibilitySummary Encode.string
        |> Encode.optional "additionalInfo" production.additionalInfo Encode.string
        |> Encode.optional "creator" production.creator encodeCreator
        |> Encode.optional "description" production.description Encode.string
        |> Encode.required "events" production.events encodeEvents
        |> Encode.optional "genre" production.genre encodeProductionsGenre
        |> Encode.required "name" production.name Encode.string
        |> Encode.optional "subtitle" production.subtitle Encode.string
        |> Encode.object


encodeProductions : List Production -> Value
encodeProductions productions =
    productions
        |> Encode.list encodeProduction


encodeVersion : Version -> Value
encodeVersion version =
    version |> versionToString |> Encode.string


versionToString : Version -> String
versionToString version =
    case version of
        V1 ->
            "v1"


encodeWheelChairPlaces : WheelChairPlaces -> Value
encodeWheelChairPlaces wheelChairPlaces =
    []
        |> Encode.required "count" wheelChairPlaces.count Encode.int
        |> Encode.optional "hasSpaceForAssistant" wheelChairPlaces.hasSpaceForAssistant Encode.bool
        |> Encode.optional "wheelchairUserCapacity" wheelChairPlaces.wheelchairUserCapacity Encode.int
        |> Encode.object
