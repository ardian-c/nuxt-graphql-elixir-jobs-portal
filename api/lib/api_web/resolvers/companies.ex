defmodule ApiWeb.Resolvers.Companies do

  require Logger

  alias Api.Repo
  alias Api.Companies
  alias Api.Companies.Company

  @desc "Companies get all"
  def get_all_companies(_, %{ offset: offset, keyword: keyword }, _) do
    companies = Company
          |> Companies.search(keyword)
          |> Repo.paginate(offset)
          |> Repo.all()
    {:ok, companies}
  end

  @desc "Companies get all - no pagination"
  def get_all_companies_no_pagination(_, %{}, _) do
    companies = Company
          |> Repo.all();

    {:ok, companies}
  end

  @desc "Company get by id"
  def get_by_id(_, %{ id: id}, _) do
    case Repo.get_by!(Company, id: id) do
      company ->
        {:ok, company}
      nil ->
        {:error, "Something went wrong, no such company"}
    end
  end

  @desc "Company add new"
  def add_company(_, %{ input: params }, _) do
    with {:ok, %Company{} = company} <- Companies.create_company(params) do
      {:ok, company}
    end
  end

  @desc "Company add logo"
  def add_company_logo(_, %{ logo: logo, company_id: company_id }, _) do
    case Companies.get_company!(company_id) do
      company ->
        # update the logo
        company
        |> Company.changeset(%{logo: logo})
        |> Repo.update()

        # {:ok, logo_path } = CompanyLogoUploader.store({ logo, company_id})
        # Logger.info ("path: #{inspect(logo_path)}")
        {:ok, company}
    end
  end
end
