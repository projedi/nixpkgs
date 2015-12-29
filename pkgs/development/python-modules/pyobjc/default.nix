{ pkgs, pythonOlder } :

with pkgs.darwin.apple_sdk.frameworks;

let

  pkgsFun = overrides:
    let 
      self = self_ // overrides;
      self_ = with self; {

  overridePackages = f:
    let newself = pkgsFun (f newself self);
    in newself;

  callPackage = pkgs.newScope self;

  version = "3.0.4";
  disabled = pythonOlder "2.7";

  pyobjc = self // { recurseForDerivations = false; };

  core = callPackage ./generic.nix {
    pkgname = "pyobjc-core";
    sha256 = "1dv80wavxz5c2zkxbfndwfrr0jh10gli83f66xszyi3qzy38hw54";
    description = "Python<->ObjC Interoperability Module";
    deps = [ Foundation Carbon Cocoa pkgs.darwin.libobjc ];
  };

  framework-Accounts = callPackage ./generic.nix {
    pkgname = "pyobjc-framework-Accounts";
    sha256 = "1gmdpisadm9xbj1cxhx8sm6y5pbya2s4h9w9yz19b5xwfd4iwvca";
    description = "Wrappers for the framework Accounts on Mac OS X";
    deps = [ framework-Cocoa Accounts ];
  };

  framework-AddressBook = callPackage ./generic.nix {
    pkgname = "pyobjc-framework-AddressBook";
    sha256 = "0l860dysrymnajx8dyaczk8gfzaxhf8bv13qbp63aaji4513xrsd";
    description = "Wrappers for the framework AddressBook on Mac OS X";
    deps = [ framework-Cocoa AddressBook ];
  };

  framework-AppleScriptKit = callPackage ./generic.nix {
    pkgname = "pyobjc-framework-AppleScriptKit";
    sha256 = "138yhqhmlhc5avhh3kjjd5kcn6kpr7q2bb33w8yvb21a874zgx7a";
    description = "Wrappers for the framework AppleScriptKit on Mac OS X";
    deps = [ framework-Cocoa AppleScriptKit ];
  };

  framework-AppleScriptObjC = callPackage ./generic.nix {
    pkgname = "pyobjc-framework-AppleScriptObjC";
    sha256 = "0l78vavm1nl3zpkvl4199z4x3f5azqn7ns6li8a6pr7kznswhwnd";
    description = "Wrappers for the framework AppleScriptObjC on Mac OS X";
    deps = [ framework-Cocoa AppleScriptObjC ];
  };

  framework-Automator = callPackage ./generic.nix {
    pkgname = "pyobjc-framework-Automator";
    sha256 = "07jn5av02djwl6jc6h4sqqspr60693ypsbwi0mvxs40f95880hf8";
    description = "Wrappers for the framework Automator on Mac OS X";
    deps = [ framework-Cocoa Automator ];
  };

  framework-CalendarStore = callPackage ./generic.nix {
    pkgname = "pyobjc-framework-CalendarStore";
    sha256 = "1w2hhzzlnzz80cav5rkv4z1c6r7bgabnkxwcn0q5aif4arkac3m9";
    description = "Wrappers for the framework CalendarStore on Mac OS X";
    deps = [ framework-Cocoa CalendarStore ];
  };

  framework-CFNetwork = callPackage ./generic.nix {
    pkgname = "pyobjc-framework-CFNetwork";
    sha256 = "0v8lc1a4mx2qg6shw1lsn215xhrqps71d91amlds5bhfwmrf9ac4";
    description = "Wrappers for the framework CFNetwork on Mac OS X";
    deps = [ framework-Cocoa CFNetwork ];
  };

  framework-Cocoa = callPackage ./generic.nix {
    pkgname = "pyobjc-framework-Cocoa";
    sha256 = "1k27x4csswd97vp12qx4mfc9vp1252h2rv9w74ms0bmb7m1lj279";
    description = "Wrappers for the Cocoa frameworks on Mac OS X";
    deps = [ core ];
  };

  framework-Collaboration = callPackage ./generic.nix {
    pkgname = "pyobjc-framework-Collaboration";
    sha256 = "0fx6fggvgwydby79s2lxlikkarsdnj2qa6cv5nb04sy5llb17css";
    description = "Wrappers for the framework Collaboration on Mac OS X";
    deps = [ framework-Cocoa Collaboration ];
  };

  framework-CoreData = callPackage ./generic.nix {
    pkgname = "pyobjc-framework-CoreData";
    sha256 = "150fdfq2gp9bfn91k94s6jlc8xhzv53gnvgfq6w35a6h097ss5w0";
    description = "Wrappers for the framework CoreData on Mac OS X";
    deps = [ framework-Cocoa CoreData ];
  };

  framework-CoreLocation = callPackage ./generic.nix {
    pkgname = "pyobjc-framework-CoreLocation";
    sha256 = "1i0fh10fpyxkjcihp8lm56jiyj9rx9gc4x8qgyn6iq24zlh5xqci";
    description = "Wrappers for the framework CoreLocation on Mac OS X";
    deps = [ framework-Cocoa CoreLocation ];
  };

  framework-CoreText = callPackage ./generic.nix {
    pkgname = "pyobjc-framework-CoreText";
    sha256 = "063fzyk1h8nzrlz2rz6a080c96pqik51birrkm0vmckz0q6478wr";
    description = "Wrappers for the framework CoreText on Mac OS X";
    deps = [ framework-Quartz CoreText ];
  };

  framework-CoreWLAN = callPackage ./generic.nix {
    pkgname = "pyobjc-framework-CoreWLAN";
    sha256 = "0i1m2qj6i5nk1i1l242dasl9ydzzfqbf738zzar3hz8dm1zhbgyp";
    description = "Wrappers for the framework CoreWLAN on Mac OS X";
    deps = [ framework-Cocoa CoreWLAN ];
  };

  # TODO: Required DictionaryServices.
  #framework-DictionaryServices = callPackage ./generic.nix {
  #  pkgname = "pyobjc-framework-DictionaryServices";
  #  sha256 = "0dk8vsqc31bqh8b6d1h9m8zia5nhsxpdpr8v2192jzw6dqfppdcg";
  #  description = "Wrappers for the framework DictionaryServices on Mac OS X";
  #  deps = [ framework-Cocoa DictionaryServices ];
  #};

  framework-DiskArbitration = callPackage ./generic.nix {
    pkgname = "pyobjc-framework-DiskArbitration";
    sha256 = "171rm3fn2adbyd5kwqn51zf91kg79bvbll0s6f092vj92n3qi2y8";
    description = "Wrappers for the framework DiskArbitration on Mac OS X";
    deps = [ framework-Cocoa DiskArbitration ];
  };

  framework-EventKit = callPackage ./generic.nix {
    pkgname = "pyobjc-framework-EventKit";
    sha256 = "02dmmjfznzndga8npaizb1cw3ci6abap48jgcasq4is4xqbx80lj";
    description = "Wrappers for the framework EventKit on Mac OS X";
    deps = [ framework-Cocoa EventKit ];
  };

  framework-ExceptionHandling = callPackage ./generic.nix {
    pkgname = "pyobjc-framework-ExceptionHandling";
    sha256 = "129yr4m5xgv299jsnf35g8w5ix0w3bn0n2c7a1n1j05asdfsiifc";
    description = "Wrappers for the framework ExceptionHandling on Mac OS X";
    deps = [ framework-Cocoa ExceptionHandling ];
  };

  # TODO: Requires FSEvents (exists as impure dep)
  #framework-FSEvents = callPackage ./generic.nix {
  #  pkgname = "pyobjc-framework-FSEvents";
  #  sha256 = "0d6vfrrhkz7pmp5n65986sjijxccrw3661w2lj67qnf19zzxjh8s";
  #  description = "Wrappers for the framework FSEvents on Mac OS X";
  #  deps = [ framework-Cocoa FSEvents ];
  #};

  framework-InputMethodKit = callPackage ./generic.nix {
    pkgname = "pyobjc-framework-InputMethodKit";
    sha256 = "13fzp3njql90dv7jy23pvcrdfhgri2r7pnzxvk8says3cj43im4j";
    description = "Wrappers for the framework InputMethodKit on Mac OS X";
    deps = [ framework-Cocoa InputMethodKit ];
  };

  framework-InstallerPlugins = callPackage ./generic.nix {
    pkgname = "pyobjc-framework-InstallerPlugins";
    sha256 = "19k2frbjiwjd2l5ri6q1zi74x00yvr15cmsd2xm79xbcg2i7ww51";
    description = "Wrappers for the framework InstallerPlugins on Mac OS X";
    deps = [ framework-Cocoa InstallerPlugins ];
  };

  framework-InstantMessage = callPackage ./generic.nix {
    pkgname = "pyobjc-framework-InstantMessage";
    sha256 = "0hw7r5kf9falpxjrzhaxk3l7a4idk73xvbzphygsf0w6ky7g5jqf";
    description = "Wrappers for the framework InstantMessage on Mac OS X";
    deps = [ framework-Quartz InstantMessage ];
  };

  # TODO: Requires InterfaceBuilderKit
  #framework-InterfaceBuilderKit = callPackage ./generic.nix {
  #  pkgname = "pyobjc-framework-InterfaceBuilderKit";
  #  sha256 = "1zvjhqpdk7y3iawlcskjzvp1rm9ii1r5iwjzv1k79knvav8f525g";
  #  description = "Wrappers for the framework InterfaceBuilderKit on Mac OS X";
  #  deps = [ core InterfaceBuilderKit ];
  #};

  framework-LatentSemanticMapping = callPackage ./generic.nix {
    pkgname = "pyobjc-framework-LatentSemanticMapping";
    sha256 = "1zp37y5ijy9r779rr8i85k39h8r1y0b2w7ij3h2jsnzci7as6350";
    description = "Wrappers for the framework LatentSemanticMapping on Mac OS X";
    deps = [ framework-Cocoa LatentSemanticMapping ];
  };

  # TODO: Requires LaunchServices (exists as impure dep)
  #framework-LaunchServices = callPackage ./generic.nix {
  #  pkgname = "pyobjc-framework-LaunchServices";
  #  sha256 = "1qa33hqksnr5hign85sgn6q07zjgqpycxxglf7bjmwxa68yhr3gp";
  #  description = "Wrappers for the framework LaunchServices on Mac OS X";
  #  deps = [ framework-Cocoa LaunchServices ];
  #};

  # TODO: Requires Message
  #framework-Message = callPackage ./generic.nix {
  #  pkgname = "pyobjc-framework-Message";
  #  sha256 = "1nv8wm60xs11f6h6pbf2v9sifdslx7248wf7n5mvaspbjz9d8yrp";
  #  description = "Wrappers for the framework Message on Mac OS X";
  #  deps = [ core Message ];
  #};

  framework-OpenDirectory = callPackage ./generic.nix {
    pkgname = "pyobjc-framework-OpenDirectory";
    sha256 = "1hjcvix7v1xamik7j9jg0cd13bdf80mcdbx1qkwa15rnjl8s3xpb";
    description = "Wrappers for the framework OpenDirectory on Mac OS X";
    deps = [ framework-Cocoa OpenDirectory ];
  };

  framework-PreferencePanes = callPackage ./generic.nix {
    pkgname = "pyobjc-framework-PreferencePanes";
    sha256 = "01dvnqpbpm3cjwpxnaay8i0npb561v3ss6d3icl68ixgcs5lw009";
    description = "Wrappers for the framework PreferencePanes on Mac OS X";
    deps = [ framework-Cocoa PreferencePanes ];
  };

  framework-PubSub = callPackage ./generic.nix {
    pkgname = "pyobjc-framework-PubSub";
    sha256 = "11qp9z88znv3b5g775bwkzxnn1cx1d0nidxxf0ffdna87k61z16z";
    description = "Wrappers for the framework PubSub on Mac OS X";
    deps = [ framework-Cocoa PubSub ];
  };

  framework-Quartz = callPackage ./generic.nix {
    pkgname = "pyobjc-framework-Quartz";
    sha256 = "14g39iidfmkkflw41nmdj2nzpwyqaqxgg2rayq32zp8jagv8lami";
    description = "Wrappers for the Quartz frameworks on Mac OS X";
    deps = [ framework-Cocoa Quartz ];
  };

  framework-QTKit = callPackage ./generic.nix {
    pkgname = "pyobjc-framework-QTKit";
    sha256 = "1mj9frgnf1favjnzr188agiayvpzwsk0g2d66zj4siwwyaycik2d";
    description = "Wrappers for the framework QTKit on Mac OS X";
    deps = [ framework-Quartz QTKit ];
  };

  framework-ScreenSaver = callPackage ./generic.nix {
    pkgname = "pyobjc-framework-ScreenSaver";
    sha256 = "0249fjqyj4qfwdkmkazck6c4w85v3hb4hi6clgl9v7p2yjv93iyw";
    description = "Wrappers for the framework ScreenSaver on Mac OS X";
    deps = [ framework-Cocoa ScreenSaver ];
  };

  framework-ScriptingBridge = callPackage ./generic.nix {
    pkgname = "pyobjc-framework-ScriptingBridge";
    sha256 = "1ppzlpcjr6vvby2l2v53991bgj4kdg5c5qi4agb98xdlns80n19i";
    description = "Wrappers for the framework ScriptingBridge on Mac OS X";
    deps = [ framework-Cocoa ScriptingBridge ];
  };

  # TODO: Requires SearchKit (exists as impure dep)
  #framework-SearchKit = callPackage ./generic.nix {
  #  pkgname = "pyobjc-framework-SearchKit";
  #  sha256 = "1qy3d3dm92icafsi9nf3qxncyxrx3zzv7c49dmzgnbnspv27h03h";
  #  description = "Wrappers for the framework SearchKit on Mac OS X";
  #  deps = [ framework-Cocoa SearchKit ];
  #};

  # TODO: Requires ServerNotification
  #framework-ServerNotification = callPackage ./generic.nix {
  #  pkgname = "pyobjc-framework-ServerNotification";
  #  sha256 = "0mxryfynzfigki006vpbkdyswavs81i3bghd4qsrxc5hx7sbzm07";
  #  description = "Wrappers for the framework ServerNotification on Mac OS X";
  #  deps = [ core ServerNotification ];
  #};

  framework-ServiceManagement = callPackage ./generic.nix {
    pkgname = "pyobjc-framework-ServiceManagement";
    sha256 = "0dyvl91f2izm2p9vaixlg0b0wqmvrc5x93j7a3wdqzqga9dh0sbz";
    description = "Wrappers for the framework ServiceManagement on Mac OS X";
    deps = [ framework-Cocoa ServiceManagement ];
  };

  framework-Social = callPackage ./generic.nix {
    pkgname = "pyobjc-framework-Social";
    sha256 = "0g15hl04rjw00g6vh16acz53xb2xdr2fa5ibxm5vzr13d8z2aavf";
    description = "Wrappers for the framework Social on Mac OS X";
    deps = [ framework-Cocoa Social ];
  };

  framework-StoreKit = callPackage ./generic.nix {
    pkgname = "pyobjc-framework-StoreKit";
    sha256 = "07sv5ll8pbv55608q7ijcw1i3wk1a50c41jmrwj8a7vdc2b80pcv";
    description = "Wrappers for the framework StoreKit on Mac OS X";
    deps = [ framework-Cocoa StoreKit ];
  };

  framework-SyncServices = callPackage ./generic.nix {
    pkgname = "pyobjc-framework-SyncServices";
    sha256 = "1klpjbiwql7fpvmwjx5sv206w6jhzijwifjw7s0q79bzkzl2gxn1";
    description = "Wrappers for the framework SyncServices on Mac OS X";
    deps = [ framework-CoreData SyncServices ];
  };

  framework-SystemConfiguration = callPackage ./generic.nix {
    pkgname = "pyobjc-framework-SystemConfiguration";
    sha256 = "1krl8i26mrk1vsnpan8g4hcspb5rbmh6l3zbnig9r5aa2n63i9wj";
    description = "Wrappers for the framework SystemConfiguration on Mac OS X";
    deps = [ framework-Cocoa SystemConfiguration ];
  };

  framework-WebKit = callPackage ./generic.nix {
    pkgname = "pyobjc-framework-WebKit";
    sha256 = "13fzjdq0nf0g04d58sd0cmcyrlg5mfcbj3rfwnqqv3i0qz7apla6";
    description = "Wrappers for the framework WebKit on Mac OS X";
    deps = [ framework-Cocoa WebKit ];
  };

  # TODO: Requires XgridFoundation.
  #framework-XgridFoundation = callPackage ./generic.nix {
  #  pkgname = "pyobjc-framework-XgridFoundation";
  #  sha256 = "1cvdfjl4kpanmwi67mw11bv8ln9xjai5704qnibyqqszkfj7m98b";
  #  description = "Wrappers for the framework XgridFoundation on Mac OS X";
  #  deps = [ core XgridFoundation ];
  #};

    };
  in self; # pkgsFun

in pkgsFun {}
