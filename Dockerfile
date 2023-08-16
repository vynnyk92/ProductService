FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build-env
WORKDIR /src

# Copy cs projs
COPY ProductService.csproj .

# Restore as distinct layers
RUN dotnet restore

# Copy everything
COPY . ./

# Build and publish a release
RUN dotnet publish -c Release -o /app

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:7.0
WORKDIR /app
COPY --from=build-env /app .
ENTRYPOINT ["dotnet", "ProductService.dll"]