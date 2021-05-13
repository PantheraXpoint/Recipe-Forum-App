using MQTTnet;
using ResourceServer.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ResourceServer.Services.Implementation
{
    public class MQTTService
    {
        private readonly IMQTTClientService mqttClient;
        public MQTTService(MQTTClientServiceProvider provider)
        {
            mqttClient = provider.MqttClientService;
        }

       

    }
}
