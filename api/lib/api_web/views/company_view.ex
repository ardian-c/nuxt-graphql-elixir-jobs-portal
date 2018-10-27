defmodule ApiWeb.CompanyView do
  use ApiWeb, :view
  alias ApiWeb.CompanyView

  def render("index.json", %{companies: companies}) do
    %{data: render_many(companies, CompanyView, "company.json")}
  end

  def render("show.json", %{company: company}) do
    %{data: render_one(company, CompanyView, "company.json")}
  end

  def render("company.json", %{company: company}) do
    %{id: company.id,
      name: company.name,
      address: company.address,
      email: company.email,
      phone: company.phone}
  end
end
