unit GlobalLists;

(*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*
GlobalLists
2004/04 ChrstphrR - chrstphrr@tubbybears.net

--
Overview:
--
Lists used globally throughout the source, such as the Summon???Lists will
be based on classes defined here


--
Revisions:
--
0.2v initial write
TSummonMobList class created on base TRandomList class.

*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*)


interface
uses
	Classes,
	List32;


(*=============================================================================*
TRandList
2004/04/07 ChrstphrR

--
Overview:
--
Base class from which the Summon???Lists will be derived.
Holds a list that allows for random selection of Integers[] in the list.

Since this is a read-only list from the /database folder, no Save* routines
have been made.

Provides:
	TotalWeighting for Weighted Probability
	RandChoice selection routine
	Distribution toggle between Weighted and Uniform

Features:
= Toggle between Weighted/Uniform Probability.
 Load data files as class method
= Add items into the list.
= Remove items into the list.
= Safe Clear of items AND objects;
= Modify Items / Weights in the list.
	(The ID's loaded... are part of Integers[] and for derived classes, will
	 be renamed for clarity and relevance to -that- list.)


--
Revisions:
--
v0.2 [ChrstphrR] - Initial writing of this class.

*=============================================================================*)
type
	TDistType = ( distWeighted, distUniform );

Type TRandList = class(TIntList32)
private
	fDistribution : TDistType;
	fMobDB        : TIntList32; // internal pointer to MobDB list.
	fTotalWeight  : Cardinal;   // counter for Weighted Probability.

protected
	Procedure SetDistribution(
              const
              	Value : TDistType
              );

	Procedure SetMobDB(
              const
              	Value : TIntList32
              );

	Function  GetWeight(
              	Index : Integer
              ) : Cardinal;

	Procedure SetWeight(
              	Index : Integer;
              	Value : Cardinal
              );

	Function  GetTotalWeight : Cardinal;


public
	Constructor Create(
                	FileName : String;
                	DistType : TDistType = distWeighted
                ); OverLoad;
	Destructor  Destroy; OverRide;


	//CRW Compiler warning stating that this overrides the old method
	// Yes, it does - we're storing Cardinals instead of TObjects :)
{$WARNINGS OFF}
	Function	AddObject(
				const
					Item   : Cardinal;
					Weight : Cardinal
				) : Integer; OverLoad;
{$WARNINGS ON}

	procedure	Clear;
	procedure	Delete(Index: Integer);

	procedure	LoadFromFile(
				const
					FileName : String
				); OverRide;
	procedure	LoadFromStream(
					Stream : TStream
				); OverRide;

	function	RandomChoice : Cardinal;

	property	Distribution : TDistType
		read    fDistribution
		write   SetDistribution
		default distWeighted; // Assuming Weighted Probability is wanted

	property	MobDB : TIntList32
		read    fMobDB
		write   SetMobDB
		default NIL; //Safe default form

	property	Weights[Index : Integer] : Cardinal
		read    GetWeight
		write   SetWeight;

	property	TotalWeight : Cardinal
		read    GetTotalWeight;

End;(* <TClassName> ==========================================================*)


(*=============================================================================*
TSummonMobList
2004/04/09 ChrstphrR

--
Overview:
--
Implemented for SummonMobList (thus the name!)

Reads a different format in the Create() routine than the ancestor TRandList.


Optional, overloaded constructor that lets you set up all the Essentials in
one call.

FileName is the Path + Filename that contains a List of the format(s)
MobJNAME,DBweight,MVPweight,MobID
MobJNAME,DBweight,,MobID
,DBweight,,MobID

( Current MOBJNAME,DBWeight will not work, but won't corrupt the list)

* At Colus' request, I'm keeping my internal format, but reading the
a modified BUT compatible data file.  This manner promotes internal efficiency
with memory, and algorithm, AND maintains readability of the data files, which
Colus desired for ease of use for the DB devs, and users adventurous enough to
alter the data for their setup.

--
Revisions:
--
v0.2 [ChrstphrR] - Initial writing of this class.
N.B. - When this List is created, and USED in Fusion, the
SummonMobListMVP load code must be changed.

*=============================================================================*)
Type TSummonMobList = class(TRandList)
public
	Constructor	Create(
					FileName : String;
					DistType : TDistType = distWeighted
				); OverLoad;
	Destructor	Destroy; OverRide;

	procedure	LoadFromFile(
				const
					FileName : String
				); OverRide;
	procedure	LoadFromStream(
					Stream : TStream
				); OverRide;


End;(* <TClassName> ==========================================================*)





implementation
uses
	SysUtils;

(*-----------------------------------------------------------------------------*
TRandList.Create()
start: 2004/04/07 ChrstphrR

Optional, overloaded constructor that lets you set up all the Essentials in
one call.

FileName is the Path + Filename that contains a List of the format
MobID,DBWeight
*-----------------------------------------------------------------------------*)
Constructor TRandList.Create(
              FileName	: String;
              DistType	: TDistType
            );
Begin
  inherited Create;
  // Always call ancestor's routines first in Create

	Distribution := DistType;
	LoadFromFile( FileName );
End;(* TRandList.Create()
*-----------------------------------------------------------------------------*)


(*-----------------------------------------------------------------------------*
TRandList.Destroy

Clean up any messes we made inside Destroy - this is our last chance! :)
*-----------------------------------------------------------------------------*)
Destructor TRandList.Destroy;
Begin
	// Always call ancestor's routines after you clean up
	// objects you created as part of this class
	Clear;
	//CRW Clear is safe for objexts in this class -- this is NOT always so
	// such as in TStrings / TStringList derived classes.

	inherited;
End;(* T.Destroy
*-----------------------------------------------------------------------------*)






(*-----------------------------------------------------------------------------*
Property Method that safely writes Distribution value.
Input value is NEVER modified.
*-----------------------------------------------------------------------------*)
Procedure TRandList.SetDistribution(
          const
            Value : TDistType
          );
Begin
	if (Value <> fDistribution) then
    fDistribution := Value;
End;(* Proc TRandList.SetDistribution()
*-----------------------------------------------------------------------------*)


(*-----------------------------------------------------------------------------*

*-----------------------------------------------------------------------------*)
Procedure TRandList.SetMobDB(
          const
            Value : TIntList32
          );
Begin
	if (Value <> fMobDB) then
  	fMobDB := Value;
End;(* Proc TRandList.SetMobDB()
*-----------------------------------------------------------------------------*)


(*-----------------------------------------------------------------------------*
Returns appropriate total weight, based on fDistribution type.
*-----------------------------------------------------------------------------*)
Function  TRandList.GetTotalWeight : Cardinal;
Begin
  case fDistribution of
  distWeighted	:
  	Result :=	fTotalWeight;
	distUniform 	:
  	Result := Count;
  else
    Assert(
      fDistribution in [distWeighted, distUniform],
      'TRandList.GetTotalWeight -- undefined Distribution Type'
    );
    Result := 0;
  end;//case

End;(* Func TRandList.GetTotalWeight
*-----------------------------------------------------------------------------*)


(*-----------------------------------------------------------------------------*

*-----------------------------------------------------------------------------*)
Function  TRandList.GetWeight(
            Index : Integer
          ) : Cardinal;
Begin
  Result := Cardinal( Objects[Index] );
  //Compiler warns this as an unsafe Cast ... and...
  // it IS, if not controlled -- but this is one of the routines that controls
  // this cast to/from Cardinal/TObject to ensure safety.
End;(* Func TRandList.GetWeight()
*-----------------------------------------------------------------------------*)



(*-----------------------------------------------------------------------------*
Adjust Weighting at Weight[Index], and adjusts internal totalweight for the
Weighted distribuution.
*-----------------------------------------------------------------------------*)
Procedure TRandList.SetWeight(
            Index : Integer;
						Value : Cardinal
          );
Begin
  if (Index >= 0) AND (Index < Count) AND (Weights[Index] <> Value) then
    begin
    // Weight will increase or decrease depending on the end difference
    fTotalWeight := fTotalWeight + ( Value - Weights[Index] );
    Objects[Index] := TObject( Value );
    //Compiler warns this as an unsafe Cast ... and...
		// it IS, if not controlled -- but this is one of the routines that controls
		// this cast to/from Cardinal/TObject to ensure safety.
		end;//if
End;(* Proc TRandList.SetWeight()
*-----------------------------------------------------------------------------*)


(*-----------------------------------------------------------------------------*
Safely casts weight into Objects[] array.
*-----------------------------------------------------------------------------*)
Function  TRandList.AddObject(
					const
						Item		: Cardinal;
						Weight	: Cardinal
					) : Integer;
Begin
	Result := Add(Item);
	PutObject(Result, TObject(Weight));
	Inc(fTotalWeight,Weight);
End;(* Func TRandList.AddObject()
*-----------------------------------------------------------------------------*)


(*-----------------------------------------------------------------------------*

*-----------------------------------------------------------------------------*)
Procedure TRandList.Clear;
Var
	Index : Integer;
Begin
	if Count <> 0 then
	begin
		//CRW Unset Objects -- remember we're just storing Cardinals in there, not
		//"real" objects, otherwise you would be calling
		//Objects[Index].Free; before setting to NIL for safety
		for Index := 0 to Count-1 do
			Objects[Index] := NIL;

		//now call std Clear from ancestor, that resets the Integers[] etc.
		inherited Clear;
	end;
End;(* Proc TRandList.Clear
*-----------------------------------------------------------------------------*)


(*-----------------------------------------------------------------------------*

*-----------------------------------------------------------------------------*)
Procedure	TRandList.Delete(
				Index : Integer
			);
Begin
  //Don't forget to maintain the TotalWeight..
	Dec(fTotalWeight,Weights[Index]);
	//CRW - remove the object, which for these lists, set to NIL because
	// we aren't really storing objects in there, or else we'd Free before this.
	Objects[Index] := NIL;
	inherited Delete(Index);
End;(* Proc TRandList.Delete()
*-----------------------------------------------------------------------------*)


(*-----------------------------------------------------------------------------*
Added here to direct to this class' LoadFromStream 
*-----------------------------------------------------------------------------*)
Procedure TRandList.LoadFromFile(
					const
						Filename : String
					);
Var
	Stream: TStream;
Begin
	Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
	try
		LoadFromStream(Stream);
	finally
		Stream.Free;
	end;
End;(* Proc TRandList.LoadFromFile()
*-----------------------------------------------------------------------------*)




(*-----------------------------------------------------------------------------*
TRandList.LoadFromStream()
-- Assumes you're loading data in the format...
<ItemID>','<Weight>
Any String data that doesn't conform, will be ignored
(i.e., a descriptive header for the data :) )

Based heavily on routines in TStrings, ancestor of TStringList, which
TIntList32 is based on.
*-----------------------------------------------------------------------------*)
Procedure TRandList.LoadFromStream(
						Stream : TStream
					);
Var
	Size	: Integer;
	P			: PChar;
	Start	: PChar;
	S			: String;
	Line	: String;

	ItemID	: Cardinal;
	Weight	: Cardinal;
Begin
	{BeginUpdate;  }
	try
		Size := Stream.Size - Stream.Position;
		SetString(S, NIL, Size);
		P := Pointer(S);
		Stream.Read(P^, Size);
		if P <> NIL then
			begin
			while P^ <> #0 do
				begin
				Start := P;
				//Find <ItemID> Step through until you find EOL or a Comma
				while NOT (P^ IN [#0, #10, #13, #44]) do
					Inc(P);

				SetString(Line, Start, P - Start);
				ItemID := StrToIntDef( Line, 0 );
				Inc(P);

				//String Found, so find <Weight>
				Start := P;
				//search for integer until EOF found (not comma this time)
				while NOT (P^ IN [#0, #10, #13]) do
					Inc(P);
				SetString(Line, Start, P - Start);
				Weight := StrToIntDef( Line, 0 );

				// If EITHER converted integer is Zero, one or both are invalid,
				// so, do not add them if so...
				if (ItemID > 0) AND (Weight > 0) then
					AddObject( ItemID, Weight );
				if P^ = #13 then Inc(P);
				if P^ = #10 then Inc(P);

				end;//while P<>#0
			end;//if P<>NIL
	finally
		{EndUpdate;}
	end;
End;(* Proc TRandList.LoadFromSTream()
*-----------------------------------------------------------------------------*)


(*-----------------------------------------------------------------------------*
"Key" Routine behind this whole class -- generates a random choice in the
list based on the Weighting

*-----------------------------------------------------------------------------*)
Function TRandList.RandomChoice : Cardinal;
Var
	Index		: Integer;
	Tally		: Cardinal;
	Number	: Cardinal;
Begin
	case Distribution of
	distWeighted :
		begin
		//Choice based on TotalWeight.
		Number	:= Random(fTotalWeight);
		Tally		:= 0;
		Index		:= -1;
		//iterate until you get in that 'bucket' where
		repeat
			Inc(Index);
			Inc(Tally,Weights[ Index ]);
		until (Tally > Number);
		Result := Integers[ Index ];
		end;
	distUniform :
		begin
		Result := Integers[ Random(Count) ];
		end;
	else
		Assert(
			Distribution IN [distWeighted, distUniform],
			'TRandList.RandomChoice -- no choice for set Distribution'
		);
		Result := 0;
	end;
End;(* Proc TRandList.RandomChoice
*-----------------------------------------------------------------------------*)




(*-----------------------------------------------------------------------------*
Reads a different format file than the ancestor
*-----------------------------------------------------------------------------*)
Constructor TSummonMobList.Create(
							FileName	: String;
							DistType	: TDistType
						);
Begin
	inherited Create;
	// Always call ancestor's routines first in Create
	//Weil, in this case call our granddaddy's constructor...
	Clear;

	Distribution := DistType;
	LoadFromFile( FileName );

End;(* TSummonMobList.Create()
*-----------------------------------------------------------------------------*)


(*-----------------------------------------------------------------------------*

*-----------------------------------------------------------------------------*)
Destructor TSummonMobList.Destroy;
Begin
	// Always call ancestor's routines after you clean up
	// objects you created as part of this class

	//Ancestor clears out objects and integers cleanly, defer to it.
	inherited;
End;(* T.Destroy
*-----------------------------------------------------------------------------*)


(*-----------------------------------------------------------------------------*

*-----------------------------------------------------------------------------*)
Procedure TSummonMobList.LoadFromFile(
					const
						Filename : String
					);
Var
	Stream: TStream;
Begin
	Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
	try
		LoadFromStream(Stream);
	finally
		Stream.Free;
	end;
End;(* Proc TSummonMobList.LoadFromFile()
*-----------------------------------------------------------------------------*)


(*-----------------------------------------------------------------------------*
CRW 2004/04/09

We're reading an expanded format of summon_mob.txt
Mob.JNAME,DBWeight,MVPWeight,Mob.ID

This LoadFromStream handles this format, but only reads fields 2 and 4,
DBweight, and Mob.ID

Commas must be present for a line to be read, and the proper format
a number and a number, or the line is ignored.

Blank lines are also ignored, thus making the datafile read a LOT safer from
corrupting what is loaded into the list.

*-----------------------------------------------------------------------------*)
Procedure TSummonMobList.LoadFromStream(
						Stream : TStream
					);
Var
	Size	: Integer;
	P			: PChar;
	Start	: PChar;
	S			: String;
	Line	: String;

	MobID		: Cardinal;
	Weight	: Cardinal;

	//CRW internal call for clarity/brevity
	procedure GetNextToken;
	begin
		Start := P;
		while NOT (P^ IN [#0, #10, #13, #44]) do
			Inc(P);
	end;
	//

Begin
	{BeginUpdate;  }
	try
		Size := Stream.Size - Stream.Position;
		SetString(S, NIL, Size);
		P := Pointer(S);
		Stream.Read(P^, Size);
		if P <> NIL then
			begin
			while P^ <> #0 do
				begin
				//Read past MobID field (not stored)
				GetNextToken;
				Inc(P);

				//Find <DBweight> Step through until you find EOL or a Comma
				GetNextToken;
				SetString(Line, Start, P - Start);
				Weight := StrToIntDef( Line, 0 );
				Inc(P);

				//Read past MVPweight field (not stored)
				GetNextToken;
				Inc(P);

				//Find <MobID>
				GetNextToken;
				SetString(Line, Start, P - Start);
				MobID := StrToIntDef( Line, 0 );

				// If EITHER DBweight or MobID are Zero, one or both are invalid,
				// Do not add them if so...
				if (MobID > 0) AND (Weight > 0) then
					AddObject( MobID, Weight );

				// Clear off remaining chars, until new line/eof, then re-read
				// tokens in next time around the loop.
				// This cleans up stray commas, other junk text, whitespace.
				while NOT (P^ IN [#0, #10, #13]) do
					Inc(P);
				if (P^ = #13) then Inc(P);
				if (P^ = #10) then Inc(P);
				end;//while P<>#0
			end;//if P<>NIL
	finally
		{EndUpdate;}
	end;
End;(* Proc TSummonMobList.LoadFromSTream()
*-----------------------------------------------------------------------------*)






end.
