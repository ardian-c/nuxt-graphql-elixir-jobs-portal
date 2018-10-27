defmodule Api.CompaniesTest do
  use Api.DataCase

  alias Api.Companies

  describe "companies" do
    alias Api.Companies.Company

    @valid_attrs %{address: "some address", email: "some email", name: "some name", phone: "some phone"}
    @update_attrs %{address: "some updated address", email: "some updated email", name: "some updated name", phone: "some updated phone"}
    @invalid_attrs %{address: nil, email: nil, name: nil, phone: nil}

    def company_fixture(attrs \\ %{}) do
      {:ok, company} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Companies.create_company()

      company
    end

    test "list_companies/0 returns all companies" do
      company = company_fixture()
      assert Companies.list_companies() == [company]
    end

    test "get_company!/1 returns the company with given id" do
      company = company_fixture()
      assert Companies.get_company!(company.id) == company
    end

    test "create_company/1 with valid data creates a company" do
      assert {:ok, %Company{} = company} = Companies.create_company(@valid_attrs)
      assert company.address == "some address"
      assert company.email == "some email"
      assert company.name == "some name"
      assert company.phone == "some phone"
    end

    test "create_company/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Companies.create_company(@invalid_attrs)
    end

    test "update_company/2 with valid data updates the company" do
      company = company_fixture()
      assert {:ok, company} = Companies.update_company(company, @update_attrs)
      assert %Company{} = company
      assert company.address == "some updated address"
      assert company.email == "some updated email"
      assert company.name == "some updated name"
      assert company.phone == "some updated phone"
    end

    test "update_company/2 with invalid data returns error changeset" do
      company = company_fixture()
      assert {:error, %Ecto.Changeset{}} = Companies.update_company(company, @invalid_attrs)
      assert company == Companies.get_company!(company.id)
    end

    test "delete_company/1 deletes the company" do
      company = company_fixture()
      assert {:ok, %Company{}} = Companies.delete_company(company)
      assert_raise Ecto.NoResultsError, fn -> Companies.get_company!(company.id) end
    end

    test "change_company/1 returns a company changeset" do
      company = company_fixture()
      assert %Ecto.Changeset{} = Companies.change_company(company)
    end
  end
end
