FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS base
USER $APP_UID
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
ARG BUILD_CONFIGURATION=Release

WORKDIR /src

COPY ["Application/Application.csproj", "Application/"]
COPY ["Domain/Domain.csproj", "Domain/"]
COPY ["Infrastructure/Infrastructure.csproj", "Infrastructure/"]

RUN dotnet restore "Domain/Domain.csproj" \
    && dotnet restore "Infrastructure/Infrastructure.csproj" \
    && dotnet restore "Application/Application.csproj" 

COPY ./Application ./Application
COPY ./Domain ./Domain
COPY ./Infrastructure ./Infrastructure

RUN dotnet build "Domain/Domain.csproj" -c $BUILD_CONFIGURATION -o /app/build/Domain \
    && dotnet build "Infrastructure/Infrastructure.csproj" -c $BUILD_CONFIGURATION -o /app/build/Infrastructure \
    && dotnet build "Application/Application.csproj" -c $BUILD_CONFIGURATION -o /app/build/Application 

COPY ["API/API.csproj", "API/"]

RUN dotnet restore "API/API.csproj" 

WORKDIR /src/API
    
COPY ./API .
    
RUN dotnet build -c $BUILD_CONFIGURATION -o /app/build/API

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./API.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "API.dll"]
