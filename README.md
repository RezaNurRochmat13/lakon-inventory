# Tracker Inventory & Transactions API

## Deskripsi Project

Project ini adalah **Inventory & Transactions Management API** menggunakan Ruby on Rails, PostgreSQL, dan RSpec.
Fungsinya untuk:

* Mengelola **products** (CRUD)
* Mengelola **transactions** (stock in/out) dengan **rule stock available**
* Menyediakan **pagination dan filter** pada listing transaksi
* Mengembalikan response **JSON** yang konsisten untuk integrasi frontend / client

Project ini dibuat sebagai assessment coding untuk **Lakon**.

---

## Teknologi

* **Backend:** Ruby on Rails 8
* **Database:** PostgreSQL
* **Testing:** RSpec + FactoryBot
* **API format:** JSON
* **Authentication:** (opsional, bisa ditambahkan JWT di masa depan)

---

## Struktur Project

```
app/
  controllers/
      products_controller.rb
      transactions_controller.rb
  models/
    product.rb
    transaction.rb
  services/
    product_service.rb
    transaction_service.rb
spec/
  requests/
      products_spec.rb
      transactions_spec.rb
db/
  migrate/
  schema.rb
config/
  routes.rb
```

---

## Setup Project

1. **Clone repository**

```bash
git clone <repo_url>
cd <repo_folder>
```

2. **Install dependencies**

```bash
bundle install
```

3. **Setup environment variables**

```bash
cp .env.example .env
```

4. **Setup database**

```bash
cd infra
docker compose up -d
rails db:create
rails db:migrate
```

5. **Run server**

```bash
rails s
```

6. **Run tests**

```bash
bundle exec rspec
```

---

## API Endpoints

### Products

| Method | Endpoint            | Deskripsi           | Params                     |
| ------ | ------------------- | ------------------- | -------------------------- |
| GET    | `/products`     | List semua product  | -                          |
| POST   | `/products`     | Create product baru | `product: { name, stock }` |
| PUT    | `/products/:id` | Update product      | `product: { name, stock }` |

**Contoh Request & Response**

```bash
POST /products
```

```json
{
  "product": { "name": "Product A", "stock": 10 }
}
```

```json
{
  "message": "success",
  "data": { "id": 1, "name": "Product A", "stock": 10 }
}
```

---

### Transactions

| Method | Endpoint            | Deskripsi                                 | Params                                                  |
| ------ | ------------------- | ----------------------------------------- | ------------------------------------------------------- |
| GET    | `/transactions` | List transaksi dengan filter & pagination | `product_id, user_id, transaction_type, page, per_page` |
| POST   | `/transactions` | Create transaksi (stock in/out)           | `transaction: { product_id, quantity }`                 |

**Rules:**

* `POST /transactions` gagal jika **stock tidak mencukupi**, akan return 422
* Pagination default: `page=1`, `per_page=20`

**Contoh Request & Response**

```bash
POST /transactions
```

```json
{
  "transaction": { "product_id": 1, "quantity": 5 }
}
```

```json
{
  "message": "success",
  "data": { "id": 1, "product_id": 1, "quantity": 5, "transaction_type": "out" }
}
```

---

**Error Responses Example**

* Product name kosong:

```json
{
  "message": "error",
  "error": ["Name can't be blank"]
}
```

* Stock insufficient:

```json
{
  "message": "error",
  "error": "Stock insufficient"
}
```

* Product / Transaction tidak ditemukan:

```json
{
  "message": "error",
  "error": "Couldn't find Product with 'id'=999"
}
```

---

## Testing

* Semua API telah diuji menggunakan **RSpec request spec**
* Transaction logic juga diuji untuk **stock sufficient / insufficient**
* Jalankan semua test:

```bash
bundle exec rspec
```

---

## Catatan
* Service pattern digunakan untuk **business logic** (ProductService, TransactionService)
* Response format JSON konsisten: `{ message: ..., data: ... }` atau `{ message: "error", error: ... }`
* AI Tools menggunakan Windsurf VsCode dan ChatGPT
