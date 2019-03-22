module Nixfmt.Types where

import           Data.Text       hiding (concat, map)
import           Text.Megaparsec (SourcePos)

data Trivium
    = SingleSpace
    | SingleLine
    | DoubleLine
    | LineComment  Text
    | BlockComment Text
    deriving (Show, Eq, Ord)

type Trivia = [Trivium]

data Ann e = Ann
    { preTrivia  :: Trivia
    , startPos   :: Maybe SourcePos
    , annotated  :: e
    , endPos     :: Maybe SourcePos
    , postTrivia :: Trivia
    } deriving (Show)

data AST
    = Node NodeType [AST]
    | Leaf (Ann NixToken)

instance Show AST where
    show (Leaf t) = show t
    show (Node t l) = concat
        [ show t
        , "("
        , concat $ map show l
        , ")"
        ]

data NodeType
    = Abstraction
    | SetAbstraction
    | Apply
    | Assert
    | File
    | IfElse
    | Inherit
    | InheritFrom
    | List
    deriving (Show)

data NixValue
    = NixFloat Text
    | NixInt   Int
    | NixText  Text
    | NixURI   Text
    deriving (Show)

data NixToken
    = Literal    NixValue
    | Identifier Text
    | EnvPath    Text

    | TAssert
    | TElse
    | TIf
    | TIn
    | TInherit
    | TLet
    | TRec
    | TThen
    | TWith

    | TBraceOpen
    | TBraceClose
    | TBrackOpen
    | TBrackClose
    | TParenOpen
    | TParenClose

    | TAssign
    | TAt
    | TColon
    | TComma
    | TDot
    | TEllipsis
    | TQuestion
    | TSemicolon

    | TConcat
    | TNegate
    | TMerge

    | TAdd
    | TSub
    | TMul
    | TDiv

    | TAnd
    | TEqual
    | TImplies
    | TLess
    | TLessOrEqual
    | TGreater
    | TGreaterOrEqual
    | TNotEqual
    | TOr

    | TEOF

instance Show NixToken where
    show (Literal v)    = show v
    show (Identifier s) = show s
    show (EnvPath p)    = show p

    show TAssert        = "assert"
    show TElse          = "else"
    show TIf            = "if"
    show TIn            = "in"
    show TInherit       = "inherit"
    show TLet           = "let"
    show TRec           = "rec"
    show TThen          = "then"
    show TWith          = "with"

    show TBraceOpen     = "{"
    show TBraceClose    = "}"
    show TBrackOpen     = "["
    show TBrackClose    = "]"
    show TParenOpen     = "("
    show TParenClose    = ")"

    show TComma         = ","

    show TEOF           = ""
