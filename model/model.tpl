package {{.pkg}}
{{if .withCache}}
import (
  "context"
  "github.com/Masterminds/squirrel"
	"github.com/zeromicro/go-zero/core/stores/cache"
	"github.com/zeromicro/go-zero/core/stores/sqlx"
)
{{else}}
import (
  "context"
  "github.com/Masterminds/squirrel"
  "github.com/zeromicro/go-zero/core/stores/sqlx"
)
{{end}}
var _ {{.upperStartCamelObject}}Model = (*custom{{.upperStartCamelObject}}Model)(nil)

type (
	// {{.upperStartCamelObject}}Model is an interface to be customized, add more methods here,
	// and implement the added methods in custom{{.upperStartCamelObject}}Model.
	{{.upperStartCamelObject}}Model interface {
		{{.lowerStartCamelObject}}Model
    Trans(ctx context.Context, fn func(ctx context.Context, session sqlx.Session) error) error
    RowBuilder() squirrel.SelectBuilder
		CountBuilder(field string) squirrel.SelectBuilder
		SumBuilder(field string) squirrel.SelectBuilder
    FindOneByQuery(ctx context.Context, rowBuilder squirrel.SelectBuilder) (*{{.upperStartCamelObject}}, error)
		FindSum(ctx context.Context, sumBuilder squirrel.SelectBuilder) (float64, error)
		FindCount(ctx context.Context, countBuilder squirrel.SelectBuilder) (int64, error)
		FindAll(ctx context.Context, rowBuilder squirrel.SelectBuilder, orderBy string) ([]*{{.upperStartCamelObject}}, error)
		FindPageListByPage(ctx context.Context, rowBuilder squirrel.SelectBuilder, page, pageSize int64, orderBy string) ([]*{{.upperStartCamelObject}}, error)
		FindPageListByIdDESC(ctx context.Context, rowBuilder squirrel.SelectBuilder, preMinId, pageSize int64) ([]*{{.upperStartCamelObject}}, error)
		FindPageListByIdASC(ctx context.Context, rowBuilder squirrel.SelectBuilder, preMaxId, pageSize int64) ([]*{{.upperStartCamelObject}}, error)
	}

	custom{{.upperStartCamelObject}}Model struct {
		*default{{.upperStartCamelObject}}Model
	}
)

// New{{.upperStartCamelObject}}Model returns a model for the database table.
func New{{.upperStartCamelObject}}Model(conn sqlx.SqlConn{{if .withCache}}, c cache.CacheConf{{end}}) {{.upperStartCamelObject}}Model {
	return &custom{{.upperStartCamelObject}}Model{
		default{{.upperStartCamelObject}}Model: new{{.upperStartCamelObject}}Model(conn{{if .withCache}}, c{{end}}),
	}
}

func (c *custom{{.upperStartCamelObject}}Model) Trans(ctx context.Context, fn func(ctx context.Context, session sqlx.Session) error) error {
	return {{if .withCache}}c.TransactCtx{{else}}c.conn.TransactCtx{{end}}(ctx, func(ctx context.Context, session sqlx.Session) error {
		return fn(ctx, session)
	})
}

// export logic
func (c *custom{{.upperStartCamelObject}}Model) RowBuilder() squirrel.SelectBuilder {
	return squirrel.Select({{.lowerStartCamelObject}}Rows).From(c.table)
}

// export logic
func (c *custom{{.upperStartCamelObject}}Model) CountBuilder(field string) squirrel.SelectBuilder {
	return squirrel.Select("COUNT(" + field + ")").From(c.table)
}

// export logic
func (c *custom{{.upperStartCamelObject}}Model) SumBuilder(field string) squirrel.SelectBuilder {
	return squirrel.Select("IFNULL(SUM(" + field + "),0)").From(c.table)
}

func (c *custom{{.upperStartCamelObject}}Model) FindOneByQuery(ctx context.Context, rowBuilder squirrel.SelectBuilder) (*{{.upperStartCamelObject}}, error) {

	query, values, err := rowBuilder.ToSql()
	if err != nil {
		return nil, err
	}

	var resp {{.upperStartCamelObject}}
	err = {{if .withCache}}c.QueryRowNoCacheCtx{{else}}c.conn.QueryRowCtx{{end}}(ctx, &resp, query, values...)
	switch err {
	case nil:
		return &resp, nil
	default:
		return nil, err
	}
}

func (c *custom{{.upperStartCamelObject}}Model) FindSum(ctx context.Context, sumBuilder squirrel.SelectBuilder) (float64, error) {

	query, values, err := sumBuilder.ToSql()
	if err != nil {
		return 0, err
	}

	var resp float64
	err = {{if .withCache}}c.QueryRowNoCacheCtx{{else}}c.conn.QueryRowCtx{{end}}(ctx, &resp, query, values...)
	switch err {
	case nil:
		return resp, nil
	default:
		return 0, err
	}
}

func (c *custom{{.upperStartCamelObject}}Model) FindCount(ctx context.Context, countBuilder squirrel.SelectBuilder) (int64, error) {

	query, values, err := countBuilder.ToSql()
	if err != nil {
		return 0, err
	}

	var resp int64
	err = {{if .withCache}}c.QueryRowNoCacheCtx{{else}}c.conn.QueryRowCtx{{end}}(ctx, &resp, query, values...)
	switch err {
	case nil:
		return resp, nil
	default:
		return 0, err
	}
}

func (c *custom{{.upperStartCamelObject}}Model) FindAll(ctx context.Context, rowBuilder squirrel.SelectBuilder, orderBy string) ([]*{{.upperStartCamelObject}}, error) {

	if orderBy == "" {
		rowBuilder = rowBuilder.OrderBy("id DESC")
	} else {
		rowBuilder = rowBuilder.OrderBy(orderBy)
	}

	query, values, err := rowBuilder.ToSql()
	if err != nil {
		return nil, err
	}

	var resp []*{{.upperStartCamelObject}}
	err = {{if .withCache}}c.QueryRowsNoCacheCtx{{else}}c.conn.QueryRowsCtx{{end}}(ctx, &resp, query, values...)
	switch err {
	case nil:
		return resp, nil
	default:
		return nil, err
	}
}

func (c *custom{{.upperStartCamelObject}}Model) FindPageListByPage(ctx context.Context, rowBuilder squirrel.SelectBuilder, page, pageSize int64, orderBy string) ([]*{{.upperStartCamelObject}}, error) {

	if orderBy == "" {
		rowBuilder = rowBuilder.OrderBy("id DESC")
	} else {
		rowBuilder = rowBuilder.OrderBy(orderBy)
	}

	if page < 1 {
		page = 1
	}
	offset := (page - 1) * pageSize

	query, values, err := rowBuilder.Offset(uint64(offset)).Limit(uint64(pageSize)).ToSql()
	if err != nil {
		return nil, err
	}

	var resp []*{{.upperStartCamelObject}}
	err = {{if .withCache}}c.QueryRowsNoCacheCtx{{else}}c.conn.QueryRowsCtx{{end}}(ctx, &resp, query, values...)
	switch err {
	case nil:
		return resp, nil
	default:
		return nil, err
	}
}

func (c *custom{{.upperStartCamelObject}}Model) FindPageListByIdDESC(ctx context.Context, rowBuilder squirrel.SelectBuilder, preMinId, pageSize int64) ([]*{{.upperStartCamelObject}}, error) {

	if preMinId > 0 {
		rowBuilder = rowBuilder.Where(" id < ? ", preMinId)
	}

	query, values, err := rowBuilder.OrderBy("id DESC").Limit(uint64(pageSize)).ToSql()
	if err != nil {
		return nil, err
	}

	var resp []*{{.upperStartCamelObject}}
	err = {{if .withCache}}c.QueryRowsNoCacheCtx{{else}}c.conn.QueryRowsCtx{{end}}(ctx, &resp, query, values...)
	switch err {
	case nil:
		return resp, nil
	default:
		return nil, err
	}
}

// 按照id升序分页查询数据，不支持排序
func (c *custom{{.upperStartCamelObject}}Model) FindPageListByIdASC(ctx context.Context, rowBuilder squirrel.SelectBuilder, preMaxId, pageSize int64) ([]*{{.upperStartCamelObject}}, error) {

	if preMaxId > 0 {
		rowBuilder = rowBuilder.Where(" id > ? ", preMaxId)
	}

	query, values, err := rowBuilder.OrderBy("id ASC").Limit(uint64(pageSize)).ToSql()
	if err != nil {
		return nil, err
	}

	var resp []*{{.upperStartCamelObject}}
	err = {{if .withCache}}c.QueryRowsNoCacheCtx{{else}}c.conn.QueryRowsCtx{{end}}(ctx, &resp, query, values...)
	switch err {
	case nil:
		return resp, nil
	default:
		return nil, err
	}
}