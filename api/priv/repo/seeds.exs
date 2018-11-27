# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Api.Repo.insert!(%Api.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

import Comeonin.Bcrypt, only: [hashpwsalt: 1]

alias Api.Repo
alias Api.Accounts.User
alias Api.Categories.Category
alias Api.Cities.City

now = Ecto.DateTime.utc;

User |> Repo.delete_all()
Api.Repo.insert!(
  %User{first_name: "admin", last_name: "", email: "acadmin@npune.com", password_hash: hashpwsalt("aqv7B7Mdmbgp0&Y3R"), is_admin: true}
)

Category |> Repo.delete_all()
Api.Repo.insert_all(
	# %Category{ name: "Accountancy", description: "Accountancy jobs" },
	Category, [
	[name: "administrate", description: "Administratë", inserted_at: now, updated_at: now],
	[name: "arkatar", description: "Arkatar", inserted_at: now, updated_at: now],
	[name: "arkitekture", description: "Arkitekturë", inserted_at: now, updated_at: now],
	[name: "arsim-edukim", description: "Arsim & Edukim", inserted_at: now, updated_at: now],
  [name: "avokat", description: "Avokat", inserted_at: now, updated_at: now],
	[name: "banka", description: "Banka", inserted_at: now, updated_at: now],
	[name: "bujqesi", description: "Bujqësi", inserted_at: now, updated_at: now],
	[name: "call-center", description: "Call Center", inserted_at: now, updated_at: now],
	[name: "financa-kontabilitet", description: "Financa, Kontabilitet", inserted_at: now, updated_at: now],
	[name: "furrtar", description: "Furrtar", inserted_at: now, updated_at: now],
	[name: "hoteleri", description: "Hoteleri", inserted_at: now, updated_at: now],
	[name: "elektrike-elektronike-mekanike", description: "Elektrike, Elektronike, Mekanike", inserted_at: now, updated_at: now],
	[name: "it-design-programim", description: "IT, Design dhe Programim", inserted_at: now, updated_at: now],
	[name: "marketing", description: "Marketing", inserted_at: now, updated_at: now],
	[name: "menaxhment", description: "Menaxhment", inserted_at: now, updated_at: now],
	[name: "ndertimtari", description: "Ndërtimtari", inserted_at: now, updated_at: now],
	[name: "pastrues", description: "Pastrues", inserted_at: now, updated_at: now],
	[name: "rrobaqepese", description: "Rrobaqepëse", inserted_at: now, updated_at: now],
	[name: "shendetesi", description: "Shëndetësi", inserted_at: now, updated_at: now],
	[name: "sigurim", description: "Sigurim", inserted_at: now, updated_at: now],
	[name: "vozites", description: "Vozitës", inserted_at: now, updated_at: now],
	[name: "media", description: "Media", inserted_at: now, updated_at: now]
	]
)

City |> Repo.delete_all()
Api.Repo.insert_all(
	City, [
  	[name: "artane", description: "Artanë", inserted_at: now, updated_at: now],
  	[name: "burim", description: "Burim", inserted_at: now, updated_at: now],
  	[name: "dardane", description: "Dardanë", inserted_at: now, updated_at: now],
  	[name: "decan", description: "Deçan", inserted_at: now, updated_at: now],
  	[name: "drenas", description: "Drenas", inserted_at: now, updated_at: now],
  	[name: "fushe-kosove", description: "Fushë Kosovë", inserted_at: now, updated_at: now],
  	[name: "gjakove", description: "Gjakovë", inserted_at: now, updated_at: now],
  	[name: "gjilan", description: "Gjilan", inserted_at: now, updated_at: now],
  	[name: "kacanik", description: "Kaçanik", inserted_at: now, updated_at: now],
  	[name: "kastriot", description: "Kastriot", inserted_at: now, updated_at: now],
  	[name: "kline", description: "Klinë", inserted_at: now, updated_at: now],
  	[name: "lipjan", description: "Lipjan", inserted_at: now, updated_at: now],
  	[name: "malisheve", description: "Malishevë", inserted_at: now, updated_at: now],
  	[name: "mitrovice", description: "Mitrovicë", inserted_at: now, updated_at: now],
  	[name: "peje", description: "Pejë", inserted_at: now, updated_at: now],
  	[name: "podujeve", description: "Podujevë", inserted_at: now, updated_at: now],
  	[name: "prishtine", description: "Prishtinë", inserted_at: now, updated_at: now],
  	[name: "prizren", description: "Prizren", inserted_at: now, updated_at: now],
  	[name: "rahovec", description: "Rahovec", inserted_at: now, updated_at: now],
  	[name: "sharr", description: "Sharr", inserted_at: now, updated_at: now],
  	[name: "shterpce", description: "Shtërpcë", inserted_at: now, updated_at: now],
  	[name: "shtime", description: "Shtime", inserted_at: now, updated_at: now],
  	[name: "skenderaj", description: "Skënderaj", inserted_at: now, updated_at: now],
  	[name: "therande", description: "Therandë", inserted_at: now, updated_at: now],
  	[name: "viti", description: "Viti", inserted_at: now, updated_at: now],
  	[name: "vushtrri", description: "Vushtrri", inserted_at: now, updated_at: now],
  	[name: "zubin-potok", description: "Zubin Potok", inserted_at: now, updated_at: now],
  	[name: "zvecan", description: "Zveçan", inserted_at: now, updated_at: now]
	]
)