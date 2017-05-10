object SC: TSC
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 354
  Width = 544
  object DSServer: TDSServer
    Left = 56
    Top = 11
  end
  object DSTCPServerTransport: TDSTCPServerTransport
    Server = DSServer
    Filters = <
      item
        FilterId = 'PC1'
        Properties.Strings = (
          'Key=!L5D!17xJV5XeoFd')
      end
      item
        FilterId = 'RSA'
        Properties.Strings = (
          'UseGlobalKey=true'
          'KeyLength=1024'
          'KeyExponent=3')
      end
      item
        FilterId = 'ZLibCompression'
        Properties.Strings = (
          'CompressMoreThan=1024')
      end>
    AuthenticationManager = DSAuthenticationManager
    Left = 56
    Top = 73
  end
  object DSHTTPService: TDSHTTPService
    HttpPort = 8085
    Server = DSServer
    Filters = <
      item
        FilterId = 'PC1'
        Properties.Strings = (
          'Key=k7v0b5fwQdjbGvKd')
      end
      item
        FilterId = 'RSA'
        Properties.Strings = (
          'UseGlobalKey=true'
          'KeyLength=1024'
          'KeyExponent=3')
      end
      item
        FilterId = 'ZLibCompression'
        Properties.Strings = (
          'CompressMoreThan=1024')
      end>
    AuthenticationManager = DSAuthenticationManager
    Left = 56
    Top = 135
  end
  object DSAuthenticationManager: TDSAuthenticationManager
    OnUserAuthenticate = DSAuthenticationManagerUserAuthenticate
    OnUserAuthorize = DSAuthenticationManagerUserAuthorize
    Roles = <>
    Left = 56
    Top = 197
  end
  object DSServerClass: TDSServerClass
    OnGetClass = DSServerClassGetClass
    Server = DSServer
    Left = 392
    Top = 11
  end
  object cursor: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 472
    Top = 128
  end
  object link: TFDPhysFBDriverLink
    Left = 472
    Top = 72
  end
  object Conexao: TFDConnection
    LoginPrompt = False
    BeforeConnect = ConexaoBeforeConnect
    Left = 472
    Top = 16
  end
end
