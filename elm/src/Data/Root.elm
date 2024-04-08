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


type alias AddressLocation =
    { city : Maybe String
    , latitude : Maybe Float
    , longitude : Maybe Float
    , name : Maybe String
    , postalCode : Maybe String
    , streetAddress : Maybe String
    , locationType : Type
    , wheelChairPlaces : Maybe WheelChairPlaces
    }


type alias Root =
    { address : Maybe Address
    , name : String
    , productions : List Production
    , version : Version
    }


type alias VirtualLocation =
    { name : Maybe String
    , locationType : Type
    , url : Maybe String
    }


type AccessModeSufficientItem
    = Auditory
    | Tactile
    | Textual
    | Visual


type alias Accessibility =
    { accessModeSufficient : Maybe (List AccessModeSufficientItem)
    , accessibilityHazard : Maybe (List AccessibilityHazardItem)
    , accessibilitySummary : Maybe String
    }


type AccessibilityHazardItem
    = None
    | Unknown
    | FlashingHazard
    | MotionSimulationHazard
    | SoundHazard
    | NoFlashingHazard
    | NoMotionSimulationHazard
    | NoSoundHazard
    | UnknownFlashingHazard
    | UnknownMotionSimulationHazard
    | UnknownSoundHazard


type alias Address =
    { city : Maybe String
    , postalCode : Maybe String
    , streetAddress : Maybe String
    }


type alias Event =
    { duration : Maybe Int
    , endDate : Maybe String
    , locations : Maybe (List Location)
    , offers : Maybe (List Offer)
    , startDate : String
    , url : Maybe String
    }


type Genre
    = Sprechtheater
    | Performance
    | LecturePerformance
    | Tanz
    | Ballett
    | ZeitgenoessischerTanz
    | Musiktheater
    | Oper
    | Operette
    | Musical
    | SzenischesKonzert
    | Konzert
    | Sinfoniekonzert
    | Kammerkonzert
    | Figurentheater
    | Puppentheater
    | Objekttheater
    | TheaterImOeffentlichenRaum
    | GameTheater
    | Installation
    | Audiowalk
    | Hoerspiel
    | Podcast
    | Lesung
    | SzenischeLesung
    | Digitaltheater
    | PhysicalTheatre
    | KabarettComedy
    | Improtheater
    | Workshop


type Location
    = Physical AddressLocation
    | Virtual VirtualLocation


type alias Offer =
    { maxPrice : Maybe Float
    , minPrice : Float
    , name : Maybe String
    , priceCurrency : String
    , url : Maybe String
    }


type alias Participant =
    { function : Maybe String
    , names : List String
    , role : Maybe String
    }


type alias Production =
    { accessibility : Maybe Accessibility
    , additionalInfo : Maybe String
    , description : Maybe String
    , events : List Event
    , genre : Maybe Genre
    , participants : Maybe (List Participant)
    , subtitle : Maybe String
    , teaser : Maybe String
    , title : String
    }


type Type
    = AddressType
    | VirtualLocationType


type Version
    = V1


type alias WheelChairPlaces =
    { count : Int
    , hasSpaceForAssistant : Maybe Bool
    , wheelchairUserCapacity : Maybe Int
    }


addressLocationDecoder : Decoder AddressLocation
addressLocationDecoder =
    Decode.succeed AddressLocation
        |> optional "city" (Decode.nullable Decode.string) Nothing
        |> optional "latitude" (Decode.nullable Decode.float) Nothing
        |> optional "longitude" (Decode.nullable Decode.float) Nothing
        |> optional "name" (Decode.nullable Decode.string) Nothing
        |> optional "postalCode" (Decode.nullable Decode.string) Nothing
        |> optional "streetAddress" (Decode.nullable Decode.string) Nothing
        |> required "type" addressTypeDecoder
        |> optional "wheelChairPlaces" (Decode.nullable wheelChairPlacesDecoder) Nothing


rootDecoder : Decoder Root
rootDecoder =
    Decode.succeed Root
        |> optional "address" (Decode.nullable addressDecoder) Nothing
        |> required "name" Decode.string
        |> required "productions" productionsDecoder
        |> required "version" versionDecoder


virtualLocationDecoder : Decoder VirtualLocation
virtualLocationDecoder =
    Decode.succeed VirtualLocation
        |> optional "name" (Decode.nullable Decode.string) Nothing
        |> required "type" virtualTypeDecoder
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
            Ok Auditory

        "tactile" ->
            Ok Tactile

        "textual" ->
            Ok Textual

        "visual" ->
            Ok Visual

        _ ->
            Err <| "Unknown accessModeSufficientItem type: " ++ accessModeSufficientItem


accessibilityDecoder : Decoder Accessibility
accessibilityDecoder =
    Decode.succeed Accessibility
        |> optional "accessModeSufficient" (Decode.nullable accessModeSufficientDecoder) Nothing
        |> optional "accessibilityHazard" (Decode.nullable accessibilityHazardDecoder) Nothing
        |> optional "accessibilitySummary" (Decode.nullable Decode.string) Nothing


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
            Ok None

        "unknown" ->
            Ok Unknown

        "flashingHazard" ->
            Ok FlashingHazard

        "motionSimulationHazard" ->
            Ok MotionSimulationHazard

        "soundHazard" ->
            Ok SoundHazard

        "noFlashingHazard" ->
            Ok NoFlashingHazard

        "noMotionSimulationHazard" ->
            Ok NoMotionSimulationHazard

        "noSoundHazard" ->
            Ok NoSoundHazard

        "unknownFlashingHazard" ->
            Ok UnknownFlashingHazard

        "unknownMotionSimulationHazard" ->
            Ok UnknownMotionSimulationHazard

        "unknownSoundHazard" ->
            Ok UnknownSoundHazard

        _ ->
            Err <| "Unknown accessibilityHazardItem type: " ++ accessibilityHazardItem


addressDecoder : Decoder Address
addressDecoder =
    Decode.succeed Address
        |> optional "city" (Decode.nullable Decode.string) Nothing
        |> optional "postalCode" (Decode.nullable Decode.string) Nothing
        |> optional "streetAddress" (Decode.nullable Decode.string) Nothing


eventDecoder : Decoder Event
eventDecoder =
    Decode.succeed Event
        |> optional "duration" (Decode.nullable Decode.int) Nothing
        |> optional "endDate" (Decode.nullable Decode.string) Nothing
        |> optional "locations" (Decode.nullable locationsDecoder) Nothing
        |> optional "offers" (Decode.nullable offersDecoder) Nothing
        |> required "startDate" Decode.string
        |> optional "url" (Decode.nullable Decode.string) Nothing


eventsDecoder : Decoder (List Event)
eventsDecoder =
    Decode.list eventDecoder


genreDecoder : Decoder Genre
genreDecoder =
    Decode.string |> Decode.andThen (parseGenre >> Decode.fromResult)


parseGenre : String -> Result String Genre
parseGenre genre =
    case genre of
        "sprechtheater" ->
            Ok Sprechtheater

        "performance" ->
            Ok Performance

        "lecture-performance" ->
            Ok LecturePerformance

        "tanz" ->
            Ok Tanz

        "ballett" ->
            Ok Ballett

        "zeitgenoessischer-tanz" ->
            Ok ZeitgenoessischerTanz

        "musiktheater" ->
            Ok Musiktheater

        "oper" ->
            Ok Oper

        "operette" ->
            Ok Operette

        "musical" ->
            Ok Musical

        "szenisches-konzert" ->
            Ok SzenischesKonzert

        "konzert" ->
            Ok Konzert

        "sinfoniekonzert" ->
            Ok Sinfoniekonzert

        "kammerkonzert" ->
            Ok Kammerkonzert

        "figurentheater" ->
            Ok Figurentheater

        "puppentheater" ->
            Ok Puppentheater

        "objekttheater" ->
            Ok Objekttheater

        "theater-im-oeffentlichen-raum" ->
            Ok TheaterImOeffentlichenRaum

        "game-theater" ->
            Ok GameTheater

        "installation" ->
            Ok Installation

        "audiowalk" ->
            Ok Audiowalk

        "hoerspiel" ->
            Ok Hoerspiel

        "podcast" ->
            Ok Podcast

        "lesung" ->
            Ok Lesung

        "szenische-lesung" ->
            Ok SzenischeLesung

        "digitaltheater" ->
            Ok Digitaltheater

        "physical-theatre" ->
            Ok PhysicalTheatre

        "kabarett-comedy" ->
            Ok KabarettComedy

        "improtheater" ->
            Ok Improtheater

        "workshop" ->
            Ok Workshop

        _ ->
            Err <| "Unknown genre type: " ++ genre


locationDecoder : Decoder Location
locationDecoder =
    Decode.oneOf
        [ Decode.map Physical addressLocationDecoder
        , Decode.map Virtual virtualLocationDecoder
        ]


locationsDecoder : Decoder (List Location)
locationsDecoder =
    Decode.list locationDecoder


namesDecoder : Decoder (List String)
namesDecoder =
    Decode.list Decode.string


offerDecoder : Decoder Offer
offerDecoder =
    Decode.succeed Offer
        |> optional "maxPrice" (Decode.nullable Decode.float) Nothing
        |> required "minPrice" Decode.float
        |> optional "name" (Decode.nullable Decode.string) Nothing
        |> required "priceCurrency" Decode.string
        |> optional "url" (Decode.nullable Decode.string) Nothing


offersDecoder : Decoder (List Offer)
offersDecoder =
    Decode.list offerDecoder


participantDecoder : Decoder Participant
participantDecoder =
    Decode.succeed Participant
        |> optional "function" (Decode.nullable Decode.string) Nothing
        |> required "names" namesDecoder
        |> optional "role" (Decode.nullable Decode.string) Nothing


participantsDecoder : Decoder (List Participant)
participantsDecoder =
    Decode.list participantDecoder


productionDecoder : Decoder Production
productionDecoder =
    Decode.succeed Production
        |> optional "accessibility" (Decode.nullable accessibilityDecoder) Nothing
        |> optional "additionalInfo" (Decode.nullable Decode.string) Nothing
        |> optional "description" (Decode.nullable Decode.string) Nothing
        |> required "events" eventsDecoder
        |> optional "genre" (Decode.nullable genreDecoder) Nothing
        |> optional "participants" (Decode.nullable participantsDecoder) Nothing
        |> optional "subtitle" (Decode.nullable Decode.string) Nothing
        |> optional "teaser" (Decode.nullable Decode.string) Nothing
        |> required "title" Decode.string


productionsDecoder : Decoder (List Production)
productionsDecoder =
    Decode.list productionDecoder


addressTypeDecoder : Decoder Type
addressTypeDecoder =
    Decode.string |> Decode.andThen (parseAddressType >> Decode.fromResult)


parseAddressType : String -> Result String Type
parseAddressType locationType =
    case locationType of
        "Address" ->
            Ok AddressType

        "VirtualLocation" ->
            Err <| "Expected 'type' to be 'Address', but it is 'VirtualLocation'"

        _ ->
            Err <| "Unknown type type: " ++ locationType


virtualTypeDecoder : Decoder Type
virtualTypeDecoder =
    Decode.string |> Decode.andThen (parseVirtualType >> Decode.fromResult)


parseVirtualType : String -> Result String Type
parseVirtualType locationType =
    case locationType of
        "Address" ->
            Err <| "Expected 'type' to be 'VirtualLocation', but it is 'Address'"

        "VirtualLocation" ->
            Ok VirtualLocationType

        _ ->
            Err <| "Unknown type type: " ++ locationType


typeDecoder : Decoder Type
typeDecoder =
    Decode.string |> Decode.andThen (parseType >> Decode.fromResult)


parseType : String -> Result String Type
parseType locationType =
    case locationType of
        "Address" ->
            Ok AddressType

        "VirtualLocation" ->
            Ok VirtualLocationType

        _ ->
            Err <| "Unknown type type: " ++ locationType


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


encodeAddressLocation : AddressLocation -> Value
encodeAddressLocation addressLocation =
    []
        |> Encode.optional "city" addressLocation.city Encode.string
        |> Encode.optional "latitude" addressLocation.latitude Encode.float
        |> Encode.optional "longitude" addressLocation.longitude Encode.float
        |> Encode.optional "name" addressLocation.name Encode.string
        |> Encode.optional "postalCode" addressLocation.postalCode Encode.string
        |> Encode.optional "streetAddress" addressLocation.streetAddress Encode.string
        |> Encode.required "type" addressLocation.locationType encodeType
        |> Encode.optional "wheelChairPlaces" addressLocation.wheelChairPlaces encodeWheelChairPlaces
        |> Encode.object


encodeRoot : Root -> Value
encodeRoot root =
    []
        |> Encode.optional "address" root.address encodeAddress
        |> Encode.required "name" root.name Encode.string
        |> Encode.required "productions" root.productions encodeProductions
        |> Encode.required "version" root.version encodeVersion
        |> Encode.object


encodeVirtualLocation : VirtualLocation -> Value
encodeVirtualLocation virtualLocation =
    []
        |> Encode.optional "name" virtualLocation.name Encode.string
        |> Encode.required "type" virtualLocation.locationType encodeType
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
        Auditory ->
            "auditory"

        Tactile ->
            "tactile"

        Textual ->
            "textual"

        Visual ->
            "visual"


encodeAccessibility : Accessibility -> Value
encodeAccessibility accessibility =
    []
        |> Encode.optional "accessModeSufficient" accessibility.accessModeSufficient encodeAccessModeSufficient
        |> Encode.optional "accessibilityHazard" accessibility.accessibilityHazard encodeAccessibilityHazard
        |> Encode.optional "accessibilitySummary" accessibility.accessibilitySummary Encode.string
        |> Encode.object


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
        None ->
            "none"

        Unknown ->
            "unknown"

        FlashingHazard ->
            "flashingHazard"

        MotionSimulationHazard ->
            "motionSimulationHazard"

        SoundHazard ->
            "soundHazard"

        NoFlashingHazard ->
            "noFlashingHazard"

        NoMotionSimulationHazard ->
            "noMotionSimulationHazard"

        NoSoundHazard ->
            "noSoundHazard"

        UnknownFlashingHazard ->
            "unknownFlashingHazard"

        UnknownMotionSimulationHazard ->
            "unknownMotionSimulationHazard"

        UnknownSoundHazard ->
            "unknownSoundHazard"


encodeAddress : Address -> Value
encodeAddress address =
    []
        |> Encode.optional "city" address.city Encode.string
        |> Encode.optional "postalCode" address.postalCode Encode.string
        |> Encode.optional "streetAddress" address.streetAddress Encode.string
        |> Encode.object


encodeEvent : Event -> Value
encodeEvent event =
    []
        |> Encode.optional "duration" event.duration Encode.int
        |> Encode.optional "endDate" event.endDate Encode.string
        |> Encode.optional "locations" event.locations encodeLocations
        |> Encode.optional "offers" event.offers encodeOffers
        |> Encode.required "startDate" event.startDate Encode.string
        |> Encode.optional "url" event.url Encode.string
        |> Encode.object


encodeEvents : List Event -> Value
encodeEvents events =
    events
        |> Encode.list encodeEvent


encodeGenre : Genre -> Value
encodeGenre genre =
    genre |> genreToString |> Encode.string


genreToString : Genre -> String
genreToString genre =
    case genre of
        Sprechtheater ->
            "sprechtheater"

        Performance ->
            "performance"

        LecturePerformance ->
            "lecture-performance"

        Tanz ->
            "tanz"

        Ballett ->
            "ballett"

        ZeitgenoessischerTanz ->
            "zeitgenoessischer-tanz"

        Musiktheater ->
            "musiktheater"

        Oper ->
            "oper"

        Operette ->
            "operette"

        Musical ->
            "musical"

        SzenischesKonzert ->
            "szenisches-konzert"

        Konzert ->
            "konzert"

        Sinfoniekonzert ->
            "sinfoniekonzert"

        Kammerkonzert ->
            "kammerkonzert"

        Figurentheater ->
            "figurentheater"

        Puppentheater ->
            "puppentheater"

        Objekttheater ->
            "objekttheater"

        TheaterImOeffentlichenRaum ->
            "theater-im-oeffentlichen-raum"

        GameTheater ->
            "game-theater"

        Installation ->
            "installation"

        Audiowalk ->
            "audiowalk"

        Hoerspiel ->
            "hoerspiel"

        Podcast ->
            "podcast"

        Lesung ->
            "lesung"

        SzenischeLesung ->
            "szenische-lesung"

        Digitaltheater ->
            "digitaltheater"

        PhysicalTheatre ->
            "physical-theatre"

        KabarettComedy ->
            "kabarett-comedy"

        Improtheater ->
            "improtheater"

        Workshop ->
            "workshop"


encodeLocation : Location -> Value
encodeLocation location =
    case location of
        Physical address ->
            encodeAddressLocation address

        Virtual virtual ->
            encodeVirtualLocation virtual


encodeLocations : List Location -> Value
encodeLocations locations =
    locations
        |> Encode.list encodeLocation


encodeNames : List String -> Value
encodeNames names =
    names
        |> Encode.list Encode.string


encodeOffer : Offer -> Value
encodeOffer offer =
    []
        |> Encode.optional "maxPrice" offer.maxPrice Encode.float
        |> Encode.required "minPrice" offer.minPrice Encode.float
        |> Encode.optional "name" offer.name Encode.string
        |> Encode.required "priceCurrency" offer.priceCurrency Encode.string
        |> Encode.optional "url" offer.url Encode.string
        |> Encode.object


encodeOffers : List Offer -> Value
encodeOffers offers =
    offers
        |> Encode.list encodeOffer


encodeParticipant : Participant -> Value
encodeParticipant participant =
    []
        |> Encode.optional "function" participant.function Encode.string
        |> Encode.required "names" participant.names encodeNames
        |> Encode.optional "role" participant.role Encode.string
        |> Encode.object


encodeParticipants : List Participant -> Value
encodeParticipants participants =
    participants
        |> Encode.list encodeParticipant


encodeProduction : Production -> Value
encodeProduction production =
    []
        |> Encode.optional "accessibility" production.accessibility encodeAccessibility
        |> Encode.optional "additionalInfo" production.additionalInfo Encode.string
        |> Encode.optional "description" production.description Encode.string
        |> Encode.required "events" production.events encodeEvents
        |> Encode.optional "genre" production.genre encodeGenre
        |> Encode.optional "participants" production.participants encodeParticipants
        |> Encode.optional "subtitle" production.subtitle Encode.string
        |> Encode.optional "teaser" production.teaser Encode.string
        |> Encode.required "title" production.title Encode.string
        |> Encode.object


encodeProductions : List Production -> Value
encodeProductions productions =
    productions
        |> Encode.list encodeProduction


encodeType : Type -> Value
encodeType locationType =
    locationType |> typeToString |> Encode.string


typeToString : Type -> String
typeToString locationType =
    case locationType of
        AddressType ->
            "Address"

        VirtualLocationType ->
            "VirtualLocation"


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
