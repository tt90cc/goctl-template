# goctl-template

### 批量新增、批量更新、批量删除使用

#### 批量新增
```go
builder := l.svcCtx.AdModel.InsertBuilder().Columns("shop_id", "platform_id").Values(1, 1).Values(1, 2)
execResp, err := l.svcCtx.AdModel.InsertBatch(l.ctx, nil, builder)
```

#### 批量更新
```go
// 更新单个字段 Set
builder := l.svcCtx.AdModel.UpdateBuilder().Set("platform_id", 1).Where("company_id=?", 1)

// 更新多个字段 SetMap SetMap(squirrel.Eq{"platform_id": 1, "updated_at": "2023-01-01 23:59:59"})
builder := l.svcCtx.AdModel.UpdateBuilder().SetMap(squirrel.Eq{"platform_id": 1, "updated_at": "2023-01-01 23:59:59"}).Where("company_id=?", 1)

execResp, err := l.svcCtx.AdModel.UpdateBatch(l.ctx, nil, builder)
```

#### 批量删除
```go
builder := l.svcCtx.AdModel.DeleteBuilder().Where("platform_id=?", 1)
execResp, err := l.svcCtx.AdModel.DeleteBatch(l.ctx, nil, builder)
```