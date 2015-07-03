object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'PatchMe'
  ClientHeight = 482
  ClientWidth = 484
  Color = clBtnFace
  Constraints.MinHeight = 520
  Constraints.MinWidth = 500
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Icon.Data = {
    0000010001001010000001002000680400001600000028000000100000002000
    000001002000000000000004000064000000640000000000000000000000FFFF
    FF00001F7200001B6A0000176200001B6A0002247C0D0C3399601038A5890021
    77090020740000217600002176000021760000217600FFFFFF00FFFFFF00FFFF
    FF00011E700006288421113DAD921644BCBE1E50D3F8245AE7FF2359E3FF0224
    7B14001E700000217600002176000021760000217600FFFFFF00FFFFFF00FFFF
    FF001848C3591F52D7C9265FF1FF245BE8FF2157E0FF2156E0FF1C4ECEE7001F
    730000186500001F7100002278000021760000217600FFFFFF00FFFFFF00FFFF
    FF001D4ED05E1F53DACE1F55DEFF1F54DCFF1F54DCFF2259E5FF1847C2C30016
    6100082F9043021F7116001C6D000022780000217600FFFFFF00FFFFFF00FFFF
    FF001847C3311D4FD3A12158E4FF2055DFFF2055DFFF245DEDFF103AA9730729
    8245265DE9FF184AC5C100186500001D6E0000227800FFFFFF00FFFFFF00FFFF
    FF001A4CCD111D51D67C2158E5FF2056E1FF2056E1FF2259E9FF1844B5DF1B46
    B7E92053D9FB2761F6FF1847C4B9001B690000207400FFFFFF00FFFFFF00FFFF
    FF001C50D5001D53DA562158E6FF2057E4FF2057E3FF2158E7FF1944B1DE143D
    A9451F54DDF92057E3FF2966FFFF0E37A36700186400FFFFFF00FFFFFF00FFFF
    FF001A4ECF001C51D6302259E7FF2158E6FF2158E6FF235BE9FF072A891B113B
    A92B235AE8FF2158E5FF2661F8FF194ACAB100176300FFFFFF00FFFFFF00FFFF
    FF001949CA001A4CCF102158E8FF2159E9FF215AE9FF2157E3FF001C6E00123F
    B25D255DF0FF2159E8FF245EF3FF1C50D5D6001B6A00FFFFFF00FFFFFF00FFFF
    FF001F55E3001F56E3002159E9D52159EBFF235DEFFF1B4CCED2001964001948
    C1D1245EF4FF2159EAFF235CF0FF2057E6F501217606FFFFFF00FFFFFF00FFFF
    FF00225CF000225CEF00215AEC5A215AECFF225CEDFF1B4DCFD0153DA3C62053
    D6FF215CF0FF215AECFF215BEDFF245FF5FF05298625FFFFFF00FFFFFF00FFFF
    FF00215AEC00215AEC00215AEC00215BEC772159E8FF2257E0FF1743B27D1C51
    D8B1235DF0FF215BEDFF215BEDFF2764FFFF0A319748FFFFFF00FFFFFF00FFFF
    FF00215AEA00215AEA00215AEA00215BEB00245CEE8A1744BA8D0D369F00215A
    ECF2235CF0FF225BEEFF225BEEFF2866FFFF103BAC75FFFFFF00FFFFFF00FFFF
    FF00225CEB00225CEB00225CEB00225DEE00255EF100123EAE000E3AA923235D
    F1FF225CF1FF225CF0FF225CF2FF2A6AFFFF1645C192FFFFFF00FFFFFF00FFFF
    FF001F55E1001F55E1001F55E1002056E3001F54DF00113DB1001443BD502460
    F8FF245FF7FF2460F8FF235EF5FF235EF5DE0D39A834FFFFFF00FFFFFF00FFFF
    FF001D53DC001D53DC001D53DC001D53DC001C52DB001D54DF002059E94F225B
    EFFF2058E9AF1B50D8641648C91A174ACD000A329A00FFFFFF00FFFFFF000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GridPanel1: TGridPanel
    Left = 0
    Top = 0
    Width = 484
    Height = 482
    Align = alClient
    BevelOuter = bvNone
    ColumnCollection = <
      item
        Value = 100.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = Origen_Label
        Row = 0
      end
      item
        Column = 0
        Control = Origen_ListBox
        Row = 1
      end
      item
        Column = 0
        Control = Panel_Central
        Row = 2
      end
      item
        Column = 0
        Control = Destino_Label
        Row = 3
      end
      item
        Column = 0
        Control = Destino_ListBox
        Row = 4
      end
      item
        Column = 0
        Control = Panel_Inferior
        Row = 5
      end>
    RowCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 34.000000000000000000
      end
      item
        Value = 49.854471270560270000
      end
      item
        SizeStyle = ssAbsolute
        Value = 48.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 24.000000000000000000
      end
      item
        Value = 50.145528729439740000
      end
      item
        SizeStyle = ssAbsolute
        Value = 95.000000000000000000
      end>
    ShowCaption = False
    TabOrder = 0
    DesignSize = (
      484
      482)
    object Origen_Label: TLabel
      AlignWithMargins = True
      Left = 16
      Top = 15
      Width = 89
      Height = 13
      Margins.Left = 16
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 6
      Anchors = [akLeft, akBottom]
      Caption = 'Archivos de origen'
    end
    object Origen_ListBox: TListBox
      AlignWithMargins = True
      Left = 16
      Top = 34
      Width = 452
      Height = 140
      Margins.Left = 16
      Margins.Top = 0
      Margins.Right = 16
      Margins.Bottom = 0
      Align = alClient
      DoubleBuffered = True
      DragMode = dmAutomatic
      ItemHeight = 13
      MultiSelect = True
      ParentDoubleBuffered = False
      PopupMenu = Origen_PopupMenu
      Sorted = True
      TabOrder = 0
      OnDragDrop = ListBoxDragDrop
      OnDragOver = Origen_ListBoxDragOver
    end
    object Panel_Central: TPanel
      AlignWithMargins = True
      Left = 16
      Top = 174
      Width = 452
      Height = 48
      Margins.Left = 16
      Margins.Top = 0
      Margins.Right = 16
      Margins.Bottom = 0
      Anchors = [akTop, akBottom]
      BevelOuter = bvNone
      TabOrder = 1
      DesignSize = (
        452
        48)
      object Origen_Button: TButton
        Left = 8
        Top = 14
        Width = 80
        Height = 25
        Align = alCustom
        Anchors = [akLeft]
        Caption = 'A'#241'adir origen'
        TabOrder = 0
        OnClick = Origen_ButtonClick
      end
      object Borrar_Button: TButton
        Left = 126
        Top = 14
        Width = 80
        Height = 25
        Hint = 'Borrar los archivos seleccionados en origen y destino'
        Anchors = []
        Caption = 'Borrar selec.'
        TabOrder = 1
        OnClick = Borrar_ButtonClick
      end
      object BorrarTodo_Button: TButton
        Left = 245
        Top = 14
        Width = 80
        Height = 25
        Anchors = []
        Caption = 'Borrar todo'
        TabOrder = 2
        OnClick = BorrarTodo_ButtonClick
      end
      object Destino_Button: TButton
        Left = 364
        Top = 14
        Width = 80
        Height = 25
        Anchors = [akRight]
        Caption = 'A'#241'adir destino'
        TabOrder = 3
        OnClick = Destino_ButtonClick
      end
    end
    object Destino_Label: TLabel
      AlignWithMargins = True
      Left = 16
      Top = 227
      Width = 94
      Height = 13
      Margins.Left = 16
      Margins.Bottom = 6
      Anchors = [akLeft, akBottom]
      Caption = 'Archivos de destino'
      ExplicitTop = 207
    end
    object Destino_ListBox: TListBox
      AlignWithMargins = True
      Left = 16
      Top = 246
      Width = 452
      Height = 140
      Margins.Left = 16
      Margins.Top = 0
      Margins.Right = 16
      Margins.Bottom = 0
      Align = alClient
      DoubleBuffered = True
      DragMode = dmAutomatic
      ItemHeight = 13
      MultiSelect = True
      ParentDoubleBuffered = False
      PopupMenu = Destino_PopupMenu
      Sorted = True
      TabOrder = 2
      OnDragDrop = ListBoxDragDrop
      OnDragOver = Destino_ListBoxDragOver
    end
    object Panel_Inferior: TPanel
      AlignWithMargins = True
      Left = 16
      Top = 386
      Width = 452
      Height = 95
      Margins.Left = 16
      Margins.Top = 0
      Margins.Right = 16
      Margins.Bottom = 0
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 3
      DesignSize = (
        452
        95)
      object Estado_Label: TLabel
        Left = 0
        Top = 75
        Width = 125
        Height = 13
        Anchors = [akLeft, akBottom]
        Caption = 'Estado: Esperando datos.'
      end
      object xdeltaFileNamesOriegn_Label: TLabel
        Left = 148
        Top = 49
        Width = 30
        Height = 13
        Cursor = crHandPoint
        Caption = 'origen'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Visible = False
        OnClick = xdeltaFileNamesOriegn_LabelClick
      end
      object xdeltaFileNamesDestino_Label: TLabel
        Left = 148
        Top = 49
        Width = 35
        Height = 13
        Cursor = crHandPoint
        Caption = 'destino'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        OnClick = xdeltaFileNamesDestino_LabelClick
      end
      object CompressFiles_CheckBox: TCheckBox
        Left = 0
        Top = 11
        Width = 145
        Height = 17
        Anchors = [akLeft, akBottom]
        Caption = 'Comprimir archivos en zip'
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = CompressFiles_CheckBoxClick
      end
      object Crear_Button: TButton
        Left = 377
        Top = 52
        Width = 75
        Height = 25
        Align = alCustom
        Anchors = [akRight, akBottom]
        Caption = 'Crear'
        TabOrder = 4
        OnClick = Crear_ButtonClick
      end
      object DeleteFiles_CheckBox: TCheckBox
        Left = 0
        Top = 29
        Width = 153
        Height = 17
        Anchors = [akLeft, akBottom]
        Caption = 'Borrar archivos intermedios'
        Checked = True
        State = cbChecked
        TabOrder = 1
      end
      object Panel_Buffer: TPanel
        Left = 166
        Top = 4
        Width = 120
        Height = 30
        Anchors = []
        BevelOuter = bvNone
        TabOrder = 3
        DesignSize = (
          120
          30)
        object Buffer_Label: TLabel
          Left = 5
          Top = 8
          Width = 30
          Height = 13
          Anchors = [akLeft]
          Caption = 'B'#250'fer:'
          ExplicitTop = 14
        end
        object MB_Label: TLabel
          Left = 98
          Top = 8
          Width = 16
          Height = 13
          Anchors = [akLeft]
          Caption = 'MiB'
        end
        object Buffer_ComboBox: TComboBox
          Left = 38
          Top = 4
          Width = 57
          Height = 21
          Anchors = [akLeft]
          ItemIndex = 3
          TabOrder = 0
          Text = '512'
          Items.Strings = (
            '64'
            '128'
            '256'
            '512'
            '1024'
            '2048')
        end
      end
      object xdeltaFileNames_CheckBox: TCheckBox
        Left = 0
        Top = 47
        Width = 145
        Height = 17
        Hint = 
          'Si est'#225' activado, los archivos .xdelta tendr'#225'n el mismo nombre q' +
          'ue los archivos de origen o destino.'
        Anchors = [akLeft, akBottom]
        Caption = 'Usar nombre para .xdelta:'
        Color = clBtnFace
        ParentColor = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
      end
    end
  end
  object Origen_OpenDialog: TOpenDialog
    Options = [ofAllowMultiSelect, ofEnableSizing]
    Title = 'Seleccionar archivos de origen'
    Left = 56
    Top = 286
  end
  object Destino_OpenDialog: TOpenDialog
    Options = [ofAllowMultiSelect, ofEnableSizing]
    Title = 'Seleccionar archivos de destino'
    Left = 170
    Top = 286
  end
  object Parche_SaveDialog: TSaveDialog
    Filter = 'Todos los archivos|*.*'
    Left = 284
    Top = 286
  end
  object Origen_PopupMenu: TPopupMenu
    Left = 56
    Top = 96
    object Sort_Origen: TMenuItem
      Tag = 1
      Caption = 'Ordenar por nombre'
      OnClick = Origen_PopupClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object SelecAll_Origen: TMenuItem
      Tag = 2
      Caption = 'Seleccionar todo'
      OnClick = Origen_PopupClick
    end
    object SelectNone_Origen: TMenuItem
      Tag = 3
      Caption = 'Seleccionar ninguno'
      OnClick = Origen_PopupClick
    end
  end
  object Destino_PopupMenu: TPopupMenu
    Left = 168
    Top = 96
    object Sort_Destino: TMenuItem
      Tag = 1
      Caption = 'Ordenar por nombre'
      OnClick = Destino_PopupClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object SeleccAll_Destino: TMenuItem
      Tag = 2
      Caption = 'Seleccionar todo'
      OnClick = Destino_PopupClick
    end
    object SelectNone_Destino: TMenuItem
      Tag = 3
      Caption = 'Seleccionar ninguno'
      OnClick = Destino_PopupClick
    end
  end
end
