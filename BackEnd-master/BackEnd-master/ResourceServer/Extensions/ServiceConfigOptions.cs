using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using MQTTnet.Client.Options;
using ResourceServer.Constants;
using ResourceServer.Services.Implementation;
using ResourceServer.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ResourceServer.Extensions
{
    public static class ServiceConfigOptions
    {
        public static void LoadAppSetting(this IServiceCollection services, IConfiguration configuration)
        {
            services.Configure<JwtOptions>(configuration.GetSection("JwtOptions"));
        }


        public static IServiceCollection AddMqttClientHostedService(this IServiceCollection services)
        {
            services.AddMqttClientServiceWithConfig(aspOptionBuilder =>
            {
                var clientSettinigs = AppSettingsProvider.MQTTClientSettings;
                var brokerHostSettings = AppSettingsProvider.MQTTBrokerHostSettings;

                aspOptionBuilder
                .WithCredentials(clientSettinigs.UserName, clientSettinigs.Password)
                .WithClientId(clientSettinigs.Id)
                .WithTcpServer(brokerHostSettings.Host, brokerHostSettings.Port);
            });
            return services;
        }

        private static IServiceCollection AddMqttClientServiceWithConfig(this IServiceCollection services, Action<MQTTOptionBuilder> configure)
        {
            services.AddSingleton<IMqttClientOptions>(serviceProvider =>
            {
                var optionBuilder = new MQTTOptionBuilder(serviceProvider);
                configure(optionBuilder);
                return optionBuilder.Build();
            });
            
            services.AddSingleton<MQTTClientService>();
            
            services.AddSingleton<IHostedService>(serviceProvider =>
            {
                return serviceProvider.GetService<MQTTClientService>();
            });

            services.AddSingleton<MQTTClientServiceProvider>(serviceProvider =>
            {
                var mqttClientService = serviceProvider.GetService<MQTTClientService>();
                var mqttClientServiceProvider = new MQTTClientServiceProvider(mqttClientService);
                return mqttClientServiceProvider;
            });
            return services;
        }

        
    }
}
