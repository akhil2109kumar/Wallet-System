
# Internal Wallet Transactional System API

## Overview

This API manages users, teams, stocks, and a wallet system with transactions (credits, debits, and transfers). It supports CRUD operations for users, teams, and stocks, and allows for the purchase and sale of stocks, as well as managing wallet balances.

## Authentication

### Sign In (without external gems)
**Description:** 
Authenticates a user with their email and password, returning an access token for subsequent requests.

### Request:

**POST**  `/auth/sign_in`

**Request Body:**

```json
{
  "email": "alice@example.com",
  "password": "securepassword"
}
```

**Sample Response:**

```json
{
    "token": "bbfb88337994f2dbe68314112be19778",
    "message": "Signed in successfully"
}
```


## User Endpoints

### Create a User
**Description:** 
Registers a new user in the system.

### Request:

**POST** `/users`

**Request Body:**

```json
{
  "name": "Alice",
  "email": "alice@example.com",
  "password": "securepassword"
}
```

**Sample Response:**

```json
{
  "id": 1,
  "name": "Alice",
  "email": "alice@example.com"
}
```


### Show a User
**Description:**
Retrieves detailed information about a specific user.

### Request:

**GET** `/users/:id`

**Sample Response:**

```json
{
  "id": 1,
  "name": "Alice",
  "email": "alice@example.com"
}
```

### Update a User
**Description:**
Updates the information of a specific user.

### Request:

**PUT/PATCH** `/users/:id`

**Request Body:**

```json
{
  "name": "Alice Updated"
}
```

**Sample Response:**

```json
{
  "id": 1,
  "name": "Alice Updated",
  "email": "alice@example.com"
}
```

### Check User Wallet
**Description:** 
Fetches the current balance of a user's wallet.

### Request:

**GET** `/users/:id/wallet`

**Sample Response:**

```json
{
  "user_id": 1,
  "wallet_balance": 1000
}
```

### Credit User Wallet
**Description:** 
Adds funds to a user's wallet.

### Request:

**POST** `/users/:id/credit`

**Request Body:**

```json
{
  "amount": 2000
}
```

**Sample Response:**

```json
{
  "user_id": 1,
  "wallet_balance": 3000
}
```

### Debit User Wallet
**Description:**
Deducts funds from a user's wallet.

### Request:

**POST** `/users/:id/debit`

**Request Body:**

```json
{
  "amount": 3000
}
```

**Sample Response:**

```json
{
  "user_id": 1,
  "wallet_balance": 0
}
```


## Wallet Endpoints

### Transfer Money
**Description:** 
Transfers money between two wallets.

### Request:

**POST** `/wallets/transfer`

**Request Body:**

```json
{
  "source_wallet_id": 1,
  "target_wallet_id": 4,
  "amount": 2000
}
```

**Sample Response:**

```json
{
  "transaction_id": 123,
  "source_wallet_balance": 8000,
  "target_wallet_balance": 3000
}
```

## Team Endpoints

### Create a Team
**Description:** 
Registers a new Team in the system.

### Request:

**POST** `/teams`

**Request Body:**

```json
{
  "team": {
    "name": "Ruby Riders"
  }
}
```

**Sample Response:**

```json
{
  "id": 1,
  "name": "Ruby Riders"
}
```


### List Teams
**Description:** 
Retrives list of all teams.

### Request:

**GET** `/teams`

**Sample Response:**

```json
[
  {
    "id": 1,
    "name": "Ruby Riders"
  },
  {
    "id": 2,
    "name": "Code Masters"
  }
]
```


### Check Team Wallet
**Description:**
Retrieves the current balance of a team's wallet.

### Request:

**GET** `/teams/:id/wallet`

**Sample Response:**

```json
{
  "team_id": 1,
  "wallet_balance": 5000
}
```

### List Team Users
**Description:** 
Lists all users associated with a specific team.

### Request:

**GET** `/teams/:id/team_users`

**Sample Response:**

```json
[
  {
    "user_id": 1,
    "name": "Alice"
  },
  {
    "user_id": 2,
    "name": "Bob"
  }
]
```


### Credit Team Wallet
**Description:**
Credits funds to a team's wallet.

### Request:

**POST** `/teams/:id/credit`

**Request Body:**

```json
{
  "team_id": 1,
  "wallet_balance": 7000
}
```

**Sample Response:**

```json
{
  "id": 1,
  "name": "Ruby Riders"
}
```

### Debit Team Wallet
**Description:** 
Debits funds from a team's wallet.

### Request:

**POST** `/teams/:id/debit`

**Request Body:**

```json
{
  "amount": 3000
}
```

**Sample Response:**

```json
{
  "team_id": 1,
  "wallet_balance": 4000
}
```


### Filter Team by user name
**Description:** 
Filters teams based on a user’s name.

### Request:

**GET** `/teams/filter?user_name=vishal`

**Sample Response:**

```json
[
  {
    "id": 1,
    "name": "Ruby Riders"
  }
]
```


### Filter Team by team name
**Description:**
Filters teams based on the team name.

### Request:

**GET** `/teams/filter?team_name=Team Alpha`

**Sample Response:**

```json
[
  {
    "id": 2,
    "name": "Team Alpha"
  }
]
```


### Team transfer amount to user
**Description:**
Transfers an amount from the team wallet to a user’s wallet.

### Request:

**POST** `/teams/1/transfer_to_user`

**Request Body:**

```json
{
  "user_id": 1,
  "amount": 100.0
}
```

**Sample Response:**

```json
{
  "transaction_id": 456,
  "user_wallet_balance": 1100,
  "team_wallet_balance": 3900
}
```



## Stock Endpoints

### Create a Stock

**Description:**
Creates a new stock entry.

### Request:

**POST** `/stocks`

**Request Body:**

```json
{
  "name": "Stock A",
  "symbol": "STKA",
  "price": 20
}
```


**Sample Response:**

```json
{
  "id": 1,
  "name": "Stock A",
  "symbol": "STKA",
  "price": 20
}
```


### Check Stock Prices
**Description:**
Retrieves current prices of all stocks.

### Request:

**GET** `/stocks/prices`

**Sample Response:**

```json
[
  {
    "symbol": "STKA",
    "price": 20
  },
  {
    "symbol": "STKB",
    "price": 30
  }
]
```


### Find Stock by Name
**Description:**
Searches for a stock by its name.

### Request:

**GET** `/stocks/stocks_name/?name=Stock A`

**Sample Response:**

```json
{
  "id": 1,
  "name": "Stock A",
  "symbol": "STKA",
  "price": 20
}
```


### Check Stock by Symbol
**Description:**
Searches for a stock by its symbol.

### Request:

**GET** `/stocks/stocks_name/?symbol=DEF`

**Sample Response:**

```json
{
  "id": 2,
  "name": "Stock B",
  "symbol": "DEF",
  "price": 25
}
```


### User Buy a Stock
**Description:**
Purchases a specified quantity of a stock for a user.

### Request:

**POST** `/stock_ownerships/:id/buy`


**Request Body:**

```json
{
  "user_id": 2,
  "quantity": 5
}
```

**Sample Response:**

```json
{
    "message": "bob purchased Stock A successfully."
}
```


### Update Stock
**Description:**
Updates the information of a specific stock.

### Request:

**PATCH** `/stocks/:id`



**Request Body:**

```json
{
  "stock": {
    "price": 19
  }
}
```

**Sample Response:**

```json
{
    "price": "19.0",
    "id": 4,
    "symbol": "ABC",
    "name": "Stock A"
}
```


### Check Stock Wallet
**Description:**
Check the information of a specific stock wallet.

### Request:

**GET** `/stocks/:id/wallet`

**Sample Response:**

```json
{
    "wallet": {
        "id": 5,
        "balance": "95.0",
        "walletable_type": "Stock",
        "walletable_id": 4
    }
}
```


## Transactions

### List All Transactions
**Description:**
Retrieves a comprehensive list of all transactions recorded in the system, including credits, debits, and transfers.

### Request:

**GET** `/transactions`

**Sample Response:**

```json
[
    {
        "id": 1,
        "source_wallet_id": null,
        "target_wallet_id": 1,
        "amount": "1000.0"
    },
    {
        "id": 2,
        "source_wallet_id": null,
        "target_wallet_id": 1,
        "amount": "2000.0"
    }
]
```


### Transactions by date range
**Description:**
Retrieves transactions that occurred within a specified date range

### Request:

**GET** `/transactions/date_range?start_date=2024-10-11&end_date=2024-10-14`

**Sample Response:**

```json
[
    {
        "id": 1,
        "source_wallet_id": null,
        "target_wallet_id": 1,
        "amount": "1000.0",
        "created_at": "2024-10-13T09:48:03.117Z",
        "updated_at": "2024-10-13T09:48:03.117Z"
    },
    {
        "id": 2,
        "source_wallet_id": null,
        "target_wallet_id": 1,
        "amount": "2000.0",
        "created_at": "2024-10-13T09:49:23.155Z",
        "updated_at": "2024-10-13T09:49:23.155Z"
    }
]
```


### Transactions by wallet
**Description:**
Retrieves all transactions associated with a specific wallet

### Request:

**GET** `/transactions/wallet?wallet_id=2`

**Sample Response:**

```json
[
    {
        "id": 7,
        "source_wallet_id": 2,
        "target_wallet_id": null,
        "amount": "2000.0"
    }
]
```


### Transactions by user name
**Description:**
Filters transactions based on the specified user name

### Request:

**GET** `/transactions/filter_by_user?user_name=bob`

**Sample Response:**

```json
[
    {
        "id": 19,
        "source_wallet_id": 4,
        "target_wallet_id": 1,
        "amount": "2000.0"
    }
]
```


### Transactions by user id
**Description:**
Retrieves all transactions associated with a specific user identified by their unique ID

### Request:

**GET** `/transactions/filter_by_user?user_id=1`

**Sample Response:**

```json
[
    {
        "id": 3,
        "source_wallet_id": 1,
        "target_wallet_id": null,
        "amount": "2000.0"
    }
]
```


## Testing

To run the test suite with RSpec, use the following command:

```bash
bundle exec rspec

