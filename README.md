# FormExample

This project is a small example on how to use Gleam to share validation code in the backend and frontend.

## Requirements

- Erlang
- Elixir
- Gleam

## Running

Since this is a Phoenix project, the usuals apply here like `mix ecto.create` and `mix deps.get`, etc. Once that is done, to compile the Gleam code to use it you need to download the Gleam deps and run the build commands (for this last step there is a Makefile). So to get this running you need to do the following:

```sh
cd shared_gleam
gleam deps download
make build-gleam
```
