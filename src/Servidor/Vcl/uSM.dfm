object SM: TSM
  OldCreateOrder = False
  Height = 369
  Width = 700
  object qryContato: TFDQuery
    Connection = SC.Conexao
    SQL.Strings = (
      'SELECT * FROM CONTATO')
    Left = 393
    Top = 88
  end
  object qryContatoEmail: TFDQuery
    Connection = SC.Conexao
    SQL.Strings = (
      'SELECT * FROM CONTATO_EMAIL')
    Left = 467
    Top = 88
  end
  object qryContatoTelefone: TFDQuery
    Connection = SC.Conexao
    SQL.Strings = (
      'SELECT * FROM CONTATO_TELEFONE')
    Left = 468
    Top = 143
  end
  object qryAUX: TFDQuery
    Connection = SC.Conexao
    Left = 464
    Top = 24
  end
  object qryContatoMaster: TFDQuery
    CachedUpdates = True
    Connection = SC.Conexao
    SchemaAdapter = FDSchemaAdapter
    FetchOptions.AssignedValues = [evDetailCascade, evDetailServerCascade]
    FetchOptions.DetailCascade = True
    FetchOptions.DetailServerCascade = True
    UpdateOptions.AssignedValues = [uvFetchGeneratorsPoint, uvGeneratorName]
    UpdateOptions.FetchGeneratorsPoint = gpNone
    UpdateOptions.KeyFields = 'CODIGO'
    SQL.Strings = (
      'Select * From CONTATO')
    Left = 64
    Top = 24
  end
  object qryContatoTelefoneDetail: TFDQuery
    CachedUpdates = True
    IndexFieldNames = 'CONTATOID'
    MasterSource = dsContatoMasterTelefone
    MasterFields = 'CODIGO'
    DetailFields = 'CONTATOID'
    Connection = SC.Conexao
    SchemaAdapter = FDSchemaAdapter
    FetchOptions.AssignedValues = [evCache, evDetailCascade, evDetailServerCascade]
    UpdateOptions.AssignedValues = [uvFetchGeneratorsPoint, uvGeneratorName]
    UpdateOptions.FetchGeneratorsPoint = gpImmediate
    UpdateOptions.KeyFields = 'CODIGO'
    SQL.Strings = (
      'Select * From CONTATO_TELEFONE'
      'Where CONTATOID = :CODIGO')
    Left = 200
    Top = 120
    ParamData = <
      item
        Name = 'CODIGO'
        DataType = ftInteger
        ParamType = ptInput
        Value = 1
      end>
  end
  object dsContatoMasterTelefone: TDataSource
    DataSet = qryContatoMaster
    Left = 64
    Top = 120
  end
  object dsContatoMasterEmail: TDataSource
    DataSet = qryContatoMaster
    Left = 64
    Top = 72
  end
  object FDSchemaAdapter: TFDSchemaAdapter
    UpdateOptions.AssignedValues = [uvAutoCommitUpdates]
    UpdateOptions.AutoCommitUpdates = True
    Left = 128
    Top = 192
  end
  object qryContatoEmailDetail: TFDQuery
    CachedUpdates = True
    IndexFieldNames = 'CONTATOID'
    MasterSource = dsContatoMasterEmail
    MasterFields = 'CODIGO'
    DetailFields = 'CONTATOID'
    Connection = SC.Conexao
    SchemaAdapter = FDSchemaAdapter
    FetchOptions.AssignedValues = [evCache, evDetailCascade, evDetailServerCascade]
    FetchOptions.DetailCascade = True
    FetchOptions.DetailServerCascade = True
    UpdateOptions.AssignedValues = [uvFetchGeneratorsPoint, uvGeneratorName]
    UpdateOptions.FetchGeneratorsPoint = gpNone
    UpdateOptions.KeyFields = 'CODIGO'
    SQL.Strings = (
      'Select * From CONTATO_EMAIL'
      'Where CONTATOID = :CODIGO')
    Left = 200
    Top = 72
    ParamData = <
      item
        Name = 'CODIGO'
        DataType = ftInteger
        ParamType = ptInput
        Value = 1
      end>
  end
end
