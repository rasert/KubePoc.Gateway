FROM mcr.microsoft.com/dotnet/core/aspnet:2.2-stretch-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:2.2-stretch AS build
WORKDIR /src
COPY ["KubePoc.Gateway/KubePoc.Gateway.csproj", "KubePoc.Gateway/"]
RUN dotnet restore "KubePoc.Gateway/KubePoc.Gateway.csproj"
COPY . .
WORKDIR "/src/KubePoc.Gateway"
RUN dotnet build "KubePoc.Gateway.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "KubePoc.Gateway.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "KubePoc.Gateway.dll"]
