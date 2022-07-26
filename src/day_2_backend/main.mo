import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Buffer "mo:base/Buffer";
import Char "mo:base/Char";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";
import List "mo:base/List";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Result "mo:base/Result";
import Text "mo:base/Text";

actor Main {
  // Challenge 1 : Write a function nat_to_nat8 that converts a Nat n to a Nat8. Make sure that your function never trap.
  public func natToNat8(n : Nat ) : async Result.Result<Nat8, Text> {
    if(n < 0 or n > 255) {
      return#err("Cannot convert n to Nat8");
    };
    return#ok(Nat8.fromNat(n));
  };

  //Challenge 2 : Write a function max_number_with_n_bits that takes a Nat n and returns the maximum number than can be represented with only n-bits.
  public func maxNumberWith_n_Bits(n :Nat) :async Nat {
    return Nat.pow(2, n) - 1;
  };

  // Challenge 3 : Write a function decimal_to_bits that takes a Nat n and returns a Text corresponding
  // to the binary representation of this number.
  public func decimalToBits(n : Nat) : async Text {
    var bin: Nat =0;
    var rem = 1;
    var i = 1;
    var nAsMutableNat = n;
    while(nAsMutableNat != 0) {
      rem := nAsMutableNat  % 2;
      nAsMutableNat /= 2;
      bin+= rem * i;
      i *=10;
    };
    return Nat.toText(bin);
  };

  // Challenge 4 : Write a function capitalize_character that takes a Char c and returns the capitalized version of it.
  public func capitalizeCharacter(c : Char) : async Text {
    if(Char.isUppercase(c) or (not Char.isAlphabetic(c))) {
      return Char.toText(c);
    };
    return Text.fromChar(Char.fromNat32(Char.toNat32(c) - 32));
  };

  // Challenge 5 : Write a function capitalize_text that takes a Text t and returns the capitalized version of it.
  public func capitalizeText(t : Text) : async Text {
    let chars = Text.toIter(t);
    var result = "";

    for(element in chars) {
      if(Char.isAlphabetic(element)) {
        if(Char.isUppercase(element)) {
          result := Text.concat(result, Text.fromChar(element));
        } else {
          result := Text.concat(result, Text.fromChar(Char.fromNat32(Char.toNat32(element) - 32)));
        }
      } else {
          result := Text.concat(result, Text.fromChar(element));
      }
    };
    return result;
  };

  // Challenge 6 : Write a function is_inside that takes two arguments :
  //   a Text t and a Char c and returns a Bool indicating if c is inside t .
  public func isInside(t : Text, c : Char) : async Bool {
    for(element in Text.toIter(t)) {
      if(Char.equal(element, c)) {
        return true;
      };
    };
    return false;
  };

  // Challenge 7 : Write a function trim_whitespace that takes a text t and returns the trimmed version of t.
  // Note : Trim means removing any leading and trailing spaces from the text : trim_whitespace(" Hello ") -> "Hello".
  public func trimWhiteSpace(t : Text) : async Text {
    return Text.trim(t, #text(" "));
  };

  //Challenge 8 : Write a function duplicated_character that takes a Text t 
  //and returns the first duplicated character in t converted to Text. 
  //Note : The function should return the whole Text if there is no duplicate character : duplicated_character("Hello") ->
  // "l" & duplicated_character("World") -> "World".
  public func duplicateCharacter(t : Text) : async Text {
    // create an empty list
    var list : List.List<Char> = List.nil();
    
    // loop through the iter of t, if it contains, return element
    // else add element to list
    label l for(element in Text.toIter(t)) {
      // prevent it from counting spaces
      if(not Char.isAlphabetic(element)) {
        continue l;
      };
      let temp = List.find(list, func (c : Char) : Bool {
        element == c;
      });
      if(temp == null) {
        list := List.push(element, list);
      }
      else {
        return Text.fromChar(element);
      }
    };

    return t;
  };


  //Challenge 9 : Write a function size_in_bytes that takes Text t and returns the number of bytes this text takes when encoded as UTF-8.
  public func sizeInBytes(t : Text ) : async Nat {
    // Convert it to blob and get its bytes
    return Text.encodeUtf8(t).size();
  };

  // Chalenge 10: Bubble sort
  public func bubbleSort(arr :[Nat]) : async [Nat] {
    if(arr.size() < 2) {
      return arr;
    };
    let arrMut: [var Nat] = Array.thaw(arr);
    let n = arrMut.size();
    var i = 0;
    while(i < n - 1) {
      var j = 0;
      while( j < n - i - 1) {
        if(arrMut[j] > arrMut[j + 1]) {
          let temp = arrMut[j];
          arrMut[j] := arrMut[j + 1];
          arrMut[j + 1] := temp;
        };
        j+=1;
      };
      i+=1;
    };

    return Array.freeze(arrMut);
  };



  // Challenge 11 : Write a function nat_opt_to_nat that takes two parameters : n of type ?Nat and m of type Nat . 
  // This function will return the value of n if n is not null and if n is null it will default to the value of m.
  public func natOptToNat(n : ?Nat, m : Nat): async Nat {
    switch(n) {
      case (null) {
        return m;
      };
      case (?e) {
        return e;
      };
    }
  };

  // Challenge 12 : Write a function day_of_the_week that takes a Nat n and returns a Text value corresponding to the day.
  // If n doesn't correspond to any day it will return null .
  public func dayOfTheWeek(n : Nat) : async ?Text {
    if( n < 1 or n > 7) {
      return null;
    };

    switch(n) {
      case (1) {
        return ?"Monday";
      };
      case (2) {
       return ?"Tuesday";
      };
      case (3) {
       return ?"Wednesday";
      };
      case (4) {
       return ?"Thursday";
      };
      case (5) {
       return ?"Friday";
      };
      case (6) {
        return? "Saturday";
      };
      case (7) {
        ?"Sunday";
      };
      case (e) {
        return ?"Something bad happened";
      };
    }
  };

  // Challenge 13 : Write a function populate_array that takes an array [?Nat] 
  // and returns an array [Nat] where all null values have been replaced by 0.
  // Recursion is the only way that we know :<
  public func populateArray(arr : [?Nat]) : async [Nat] {
    let temp = Array.map(arr, func (element : ?Nat) :  Nat {
      switch(element) {
        case (null) {
          return 0;
        };
        case (?any) {
          return any;
        }
      }
    }); 

    return temp;
  };

  // Challenge 14 : Write a function sum_of_array that takes an array [Nat] and returns the sum of a values in the array.
  public func sumOfArray(arr : [Nat]) : async Nat {
    if(arr.size() == 0){
      return 0;
    };

    // I don't even know what I'm doing :<<
    var sum = 0;
    let temp = Array.map(arr, func (element: Nat) : Nat {
        sum := sum + element;
        Debug.print(Nat.toText(sum));
        return sum;
    });
    

    return temp[temp.size()- 1];
  };

  //Challenge 15 : Write a function squared_array that takes an array [Nat] and returns a new array where each value has been squared.
  // Just using map
  public func squaredArray(arr:[Nat]) : async [Nat] {
    return Array.map(arr, func (element : Nat) : Nat {
      return Nat.pow(element, 2);
    });
  };

  //Challenge 16 : Write a function increase_by_index that takes an array [Nat]
  // and returns a new array where each number has been increased by it's corresponding index.
  public func increaseByIndex(arr : [Nat]) : async [Nat] {
    var index:Nat = 0;
    return Array.map(arr, func (element : Nat) : Nat {
      let temp:Nat = element + index;
      index+=1;
      return temp;
    });
  };

  //Challenge 17 : Write a higher order function contains<A> that takes 3 parameters : an array [A] ,
  // a of type A and a function f that takes a tuple of type (A,A) and returns a boolean.
  // This function should return a boolean indicating whether or not a is present in the array
  public func contains(arr: [Nat], a : Nat) : async Bool {
    let temp = Array.find(arr, func (element : Nat) : Bool {
      element == a;
    });

    switch(temp) {
      case (null) {
        return false;
      };
      case (?any) {
        return true;
      }
    }
  };





}