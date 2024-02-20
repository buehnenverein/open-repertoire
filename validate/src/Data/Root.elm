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


type AccessibilityHazard
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


type alias Event =
    { duration : Maybe Int
    , endDate : Maybe String
    , locations : Maybe (List Location)
    , offers : Maybe (List Offer)
    , startDate : String
    , url : Maybe String
    }


type alias Participant =
    { function : Maybe Function
    , names : List String
    , roleName : Maybe String
    }


type alias AddressLocation =
    { city : Maybe String
    , latitude : Maybe Float
    , longitude : Maybe Float
    , name : Maybe String
    , postalCode : Maybe String
    , streetAddress : Maybe String
    , locationType : LocationType
    , wheelChairPlaces : Maybe WheelChairPlaces
    }


type AccessMode
    = Auditory
    | Tactile
    | Textual
    | Visual


type alias Offer =
    { maxPrice : Maybe Float
    , minPrice : Float
    , name : Maybe String
    , priceCurrency : String
    , url : Maybe String
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


type alias VirtualLocation =
    { name : Maybe String
    , locationType : LocationType
    , url : Maybe String
    }


type alias Root =
    { address : Maybe Address
    , name : String
    , productions : List Production
    , version : Version
    }


type alias Accessibility =
    { accessModeSufficient : Maybe (List AccessMode)
    , accessibilityHazard : Maybe (List AccessibilityHazard)
    , accessibilitySummary : Maybe String
    }


type alias Address =
    { city : Maybe String
    , postalCode : Maybe String
    , streetAddress : Maybe String
    }


type Function
    = Akrobatik
    | Alles
    | Assistenz
    | Beratung
    | Buehne
    | Choreographie
    | Clownerie
    | Dramaturgie
    | ExpertinDesAlltags
    | Fotografie
    | Gebaerdensprache
    | Gesang
    | Grafik
    | Inszenierung
    | Jonglage
    | KameraVideo
    | Komposition
    | Konzept
    | Kostuem
    | KuenstlerischeLeitung
    | Licht
    | LiveMusik
    | Marketing
    | Maske
    | Moderation
    | Musik
    | MusikalischeLeitung
    | PerformanceFunction
    | Produktion
    | Programmierung
    | Puppenbau
    | Puppenspiel
    | Regie
    | Rigging
    | Schauspiel
    | Sound
    | TanzFunction
    | Technik
    | TechnischeLeitung
    | Text
    | Ton
    | Uebersetzung
    | Vermittlung
    | VirtualRealityDesign


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


type LocationType
    = AddressType
    | VirtualLocationType


type Version
    = V1


type alias WheelChairPlaces =
    { count : Int
    , hasSpaceForAssistant : Maybe Bool
    , wheelchairUserCapacity : Maybe Int
    }


accessibilityHazardDecoder : Decoder AccessibilityHazard
accessibilityHazardDecoder =
    Decode.string |> Decode.andThen (parseAccessibilityHazard >> Decode.fromResult)


parseAccessibilityHazard : String -> Result String AccessibilityHazard
parseAccessibilityHazard accessibilityHazard =
    case accessibilityHazard of
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
            Err <| "Unknown accessibilityHazard type: " ++ accessibilityHazard


eventDecoder : Decoder Event
eventDecoder =
    Decode.succeed Event
        |> optional "duration" (Decode.nullable Decode.int) Nothing
        |> optional "endDate" (Decode.nullable Decode.string) Nothing
        |> optional "locations" (Decode.nullable locationsDecoder) Nothing
        |> optional "offers" (Decode.nullable offersDecoder) Nothing
        |> required "startDate" Decode.string
        |> optional "url" (Decode.nullable Decode.string) Nothing


participantDecoder : Decoder Participant
participantDecoder =
    Decode.succeed Participant
        |> optional "function" (Decode.nullable functionDecoder) Nothing
        |> required "names" namesDecoder
        |> optional "roleName" (Decode.nullable Decode.string) Nothing


addressLocationDecoder : Decoder Location
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
        |> Decode.map Physical


accessModeDecoder : Decoder AccessMode
accessModeDecoder =
    Decode.string |> Decode.andThen (parseAccessMode >> Decode.fromResult)


parseAccessMode : String -> Result String AccessMode
parseAccessMode accessMode =
    case accessMode of
        "auditory" ->
            Ok Auditory

        "tactile" ->
            Ok Tactile

        "textual" ->
            Ok Textual

        "visual" ->
            Ok Visual

        _ ->
            Err <| "Unknown accessMode type: " ++ accessMode


offerDecoder : Decoder Offer
offerDecoder =
    Decode.succeed Offer
        |> optional "maxPrice" (Decode.nullable Decode.float) Nothing
        |> required "minPrice" Decode.float
        |> optional "name" (Decode.nullable Decode.string) Nothing
        |> required "priceCurrency" Decode.string
        |> optional "url" (Decode.nullable Decode.string) Nothing


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


rootDecoder : Decoder Root
rootDecoder =
    Decode.succeed Root
        |> optional "address" (Decode.nullable addressDecoder) Nothing
        |> required "name" Decode.string
        |> required "productions" productionsDecoder
        |> required "version" versionDecoder


accessModeSufficientDecoder : Decoder (List AccessMode)
accessModeSufficientDecoder =
    Decode.list accessModeDecoder


accessibilityDecoder : Decoder Accessibility
accessibilityDecoder =
    Decode.succeed Accessibility
        |> optional "accessModeSufficient" (Decode.nullable accessModeSufficientDecoder) Nothing
        |> optional "accessibilityHazard" (Decode.nullable accessibilityHazardsDecoder) Nothing
        |> optional "accessibilitySummary" (Decode.nullable Decode.string) Nothing


accessibilityHazardsDecoder : Decoder (List AccessibilityHazard)
accessibilityHazardsDecoder =
    Decode.list accessibilityHazardDecoder


addressDecoder : Decoder Address
addressDecoder =
    Decode.succeed Address
        |> optional "city" (Decode.nullable Decode.string) Nothing
        |> optional "postalCode" (Decode.nullable Decode.string) Nothing
        |> optional "streetAddress" (Decode.nullable Decode.string) Nothing


eventsDecoder : Decoder (List Event)
eventsDecoder =
    Decode.list eventDecoder


functionDecoder : Decoder Function
functionDecoder =
    Decode.string |> Decode.andThen (parseFunction >> Decode.fromResult)


parseFunction : String -> Result String Function
parseFunction function =
    case function of
        "akrobatik" ->
            Ok Akrobatik

        "alles" ->
            Ok Alles

        "assistenz" ->
            Ok Assistenz

        "beratung" ->
            Ok Beratung

        "buehne" ->
            Ok Buehne

        "choreographie" ->
            Ok Choreographie

        "clownerie" ->
            Ok Clownerie

        "dramaturgie" ->
            Ok Dramaturgie

        "expertin-des-alltags" ->
            Ok ExpertinDesAlltags

        "fotografie" ->
            Ok Fotografie

        "gebaerdensprache" ->
            Ok Gebaerdensprache

        "gesang" ->
            Ok Gesang

        "grafik" ->
            Ok Grafik

        "inszenierung" ->
            Ok Inszenierung

        "jonglage" ->
            Ok Jonglage

        "kamera-video" ->
            Ok KameraVideo

        "komposition" ->
            Ok Komposition

        "konzept" ->
            Ok Konzept

        "kostuem" ->
            Ok Kostuem

        "kuenstlerische-leitung" ->
            Ok KuenstlerischeLeitung

        "licht" ->
            Ok Licht

        "live-musik" ->
            Ok LiveMusik

        "marketing" ->
            Ok Marketing

        "maske" ->
            Ok Maske

        "moderation" ->
            Ok Moderation

        "musik" ->
            Ok Musik

        "musikalische-leitung" ->
            Ok MusikalischeLeitung

        "performance" ->
            Ok PerformanceFunction

        "produktion" ->
            Ok Produktion

        "programmierung" ->
            Ok Programmierung

        "puppenbau" ->
            Ok Puppenbau

        "puppenspiel" ->
            Ok Puppenspiel

        "regie" ->
            Ok Regie

        "rigging" ->
            Ok Rigging

        "schauspiel" ->
            Ok Schauspiel

        "sound" ->
            Ok Sound

        "tanz" ->
            Ok TanzFunction

        "technik" ->
            Ok Technik

        "technische-leitung" ->
            Ok TechnischeLeitung

        "text" ->
            Ok Text

        "ton" ->
            Ok Ton

        "uebersetzung" ->
            Ok Uebersetzung

        "vermittlung" ->
            Ok Vermittlung

        "virtual-reality-design" ->
            Ok VirtualRealityDesign

        _ ->
            Err <| "Unknown function type: " ++ function


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
    Decode.oneOf [ addressLocationDecoder, virtualLocationDecoder ]


virtualLocationDecoder : Decoder Location
virtualLocationDecoder =
    Decode.succeed VirtualLocation
        |> optional "name" (Decode.nullable Decode.string) Nothing
        |> required "type" virtualLocationTypeDecoder
        |> optional "url" (Decode.nullable Decode.string) Nothing
        |> Decode.map Virtual


virtualLocationTypeDecoder : Decoder LocationType
virtualLocationTypeDecoder =
    Decode.string |> Decode.andThen (parseVirtualLocationType >> Decode.fromResult)


parseVirtualLocationType : String -> Result String LocationType
parseVirtualLocationType value =
    case value of
        "VirtualLocation" ->
            Ok VirtualLocationType

        _ ->
            Err <| "Unknown type type: " ++ value


addressTypeDecoder : Decoder LocationType
addressTypeDecoder =
    Decode.string |> Decode.andThen (parseAddressType >> Decode.fromResult)


parseAddressType : String -> Result String LocationType
parseAddressType value =
    case value of
        "Address" ->
            Ok AddressType

        _ ->
            Err <| "Unknown type type: " ++ value


locationsDecoder : Decoder (List Location)
locationsDecoder =
    Decode.list locationDecoder


namesDecoder : Decoder (List String)
namesDecoder =
    Decode.list Decode.string


offersDecoder : Decoder (List Offer)
offersDecoder =
    Decode.list offerDecoder


participantsDecoder : Decoder (List Participant)
participantsDecoder =
    Decode.list participantDecoder


productionsDecoder : Decoder (List Production)
productionsDecoder =
    Decode.list productionDecoder


typeDecoder : Decoder LocationType
typeDecoder =
    Decode.string |> Decode.andThen (parseType >> Decode.fromResult)


parseType : String -> Result String LocationType
parseType value =
    case value of
        "Address" ->
            Ok AddressType

        "VirtualLocation" ->
            Ok VirtualLocationType

        _ ->
            Err <| "Unknown type type: " ++ value


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


encodeAccessibilityHazard : AccessibilityHazard -> Value
encodeAccessibilityHazard accessibilityHazard =
    accessibilityHazard |> accessibilityHazardToString |> Encode.string


accessibilityHazardToString : AccessibilityHazard -> String
accessibilityHazardToString accessibilityHazard =
    case accessibilityHazard of
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


encodeParticipant : Participant -> Value
encodeParticipant participant =
    []
        |> Encode.optional "function" participant.function encodeFunction
        |> Encode.required "names" participant.names encodeNames
        |> Encode.optional "roleName" participant.roleName Encode.string
        |> Encode.object


encodeAddressLocation : AddressLocation -> Value
encodeAddressLocation addressLocation =
    []
        |> Encode.optional "city" addressLocation.city Encode.string
        |> Encode.optional "latitude" addressLocation.latitude Encode.float
        |> Encode.optional "longitude" addressLocation.longitude Encode.float
        |> Encode.optional "name" addressLocation.name Encode.string
        |> Encode.optional "postalCode" addressLocation.postalCode Encode.string
        |> Encode.optional "streetAddress" addressLocation.streetAddress Encode.string
        |> Encode.required "type" addressLocation.locationType encodeLocationType
        |> Encode.optional "wheelChairPlaces" addressLocation.wheelChairPlaces encodeWheelChairPlaces
        |> Encode.object


encodeAccessMode : AccessMode -> Value
encodeAccessMode accessMode =
    accessMode |> accessModeToString |> Encode.string


accessModeToString : AccessMode -> String
accessModeToString accessMode =
    case accessMode of
        Auditory ->
            "auditory"

        Tactile ->
            "tactile"

        Textual ->
            "textual"

        Visual ->
            "visual"


encodeOffer : Offer -> Value
encodeOffer offer =
    []
        |> Encode.optional "maxPrice" offer.maxPrice Encode.float
        |> Encode.required "minPrice" offer.minPrice Encode.float
        |> Encode.optional "name" offer.name Encode.string
        |> Encode.required "priceCurrency" offer.priceCurrency Encode.string
        |> Encode.optional "url" offer.url Encode.string
        |> Encode.object


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


encodeVirtualLocation : VirtualLocation -> Value
encodeVirtualLocation virtualLocation =
    []
        |> Encode.optional "name" virtualLocation.name Encode.string
        |> Encode.required "type" virtualLocation.locationType encodeLocationType
        |> Encode.optional "url" virtualLocation.url Encode.string
        |> Encode.object


encodeRoot : Root -> Value
encodeRoot root =
    []
        |> Encode.optional "address" root.address encodeAddress
        |> Encode.required "name" root.name Encode.string
        |> Encode.required "productions" root.productions encodeProductions
        |> Encode.required "version" root.version encodeVersion
        |> Encode.object


encodeAccessModeSufficient : List AccessMode -> Value
encodeAccessModeSufficient accessModeSufficient =
    accessModeSufficient
        |> Encode.list encodeAccessMode


encodeAccessibility : Accessibility -> Value
encodeAccessibility accessibility =
    []
        |> Encode.optional "accessModeSufficient" accessibility.accessModeSufficient encodeAccessModeSufficient
        |> Encode.optional "accessibilityHazard" accessibility.accessibilityHazard encodeAccessibilityHazards
        |> Encode.optional "accessibilitySummary" accessibility.accessibilitySummary Encode.string
        |> Encode.object


encodeAccessibilityHazards : List AccessibilityHazard -> Value
encodeAccessibilityHazards accessibilityHazard =
    accessibilityHazard
        |> Encode.list encodeAccessibilityHazard


encodeAddress : Address -> Value
encodeAddress address =
    []
        |> Encode.optional "city" address.city Encode.string
        |> Encode.optional "postalCode" address.postalCode Encode.string
        |> Encode.optional "streetAddress" address.streetAddress Encode.string
        |> Encode.object


encodeEvents : List Event -> Value
encodeEvents events =
    events
        |> Encode.list encodeEvent


encodeFunction : Function -> Value
encodeFunction function =
    function |> functionToString |> Encode.string


functionToString : Function -> String
functionToString function =
    case function of
        Akrobatik ->
            "akrobatik"

        Alles ->
            "alles"

        Assistenz ->
            "assistenz"

        Beratung ->
            "beratung"

        Buehne ->
            "buehne"

        Choreographie ->
            "choreographie"

        Clownerie ->
            "clownerie"

        Dramaturgie ->
            "dramaturgie"

        ExpertinDesAlltags ->
            "expertin-des-alltags"

        Fotografie ->
            "fotografie"

        Gebaerdensprache ->
            "gebaerdensprache"

        Gesang ->
            "gesang"

        Grafik ->
            "grafik"

        Inszenierung ->
            "inszenierung"

        Jonglage ->
            "jonglage"

        KameraVideo ->
            "kamera-video"

        Komposition ->
            "komposition"

        Konzept ->
            "konzept"

        Kostuem ->
            "kostuem"

        KuenstlerischeLeitung ->
            "kuenstlerische-leitung"

        Licht ->
            "licht"

        LiveMusik ->
            "live-musik"

        Marketing ->
            "marketing"

        Maske ->
            "maske"

        Moderation ->
            "moderation"

        Musik ->
            "musik"

        MusikalischeLeitung ->
            "musikalische-leitung"

        PerformanceFunction ->
            "performance"

        Produktion ->
            "produktion"

        Programmierung ->
            "programmierung"

        Puppenbau ->
            "puppenbau"

        Puppenspiel ->
            "puppenspiel"

        Regie ->
            "regie"

        Rigging ->
            "rigging"

        Schauspiel ->
            "schauspiel"

        Sound ->
            "sound"

        TanzFunction ->
            "tanz"

        Technik ->
            "technik"

        TechnischeLeitung ->
            "technische-leitung"

        Text ->
            "text"

        Ton ->
            "ton"

        Uebersetzung ->
            "uebersetzung"

        Vermittlung ->
            "vermittlung"

        VirtualRealityDesign ->
            "virtual-reality-design"


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


encodeLocations : List Location -> Value
encodeLocations locations =
    locations
        |> Encode.list encodeLocation


encodeLocation : Location -> Value
encodeLocation location =
    case location of
        Physical address ->
            encodeAddressLocation address

        Virtual virtual ->
            encodeVirtualLocation virtual


encodeNames : List String -> Value
encodeNames names =
    names
        |> Encode.list Encode.string


encodeOffers : List Offer -> Value
encodeOffers offers =
    offers
        |> Encode.list encodeOffer


encodeParticipants : List Participant -> Value
encodeParticipants participants =
    participants
        |> Encode.list encodeParticipant


encodeProductions : List Production -> Value
encodeProductions productions =
    productions
        |> Encode.list encodeProduction


encodeLocationType : LocationType -> Value
encodeLocationType value =
    value |> locationTypeToString |> Encode.string


locationTypeToString : LocationType -> String
locationTypeToString value =
    case value of
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
