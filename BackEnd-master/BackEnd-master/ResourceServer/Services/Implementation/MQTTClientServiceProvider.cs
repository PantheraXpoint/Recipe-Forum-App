using ResourceServer.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ResourceServer.Services.Implementation
{
    public class MQTTClientServiceProvider
    {
        public readonly IMQTTClientService MqttClientService;

        public MQTTClientServiceProvider(IMQTTClientService mqttClientService)
        {
            MqttClientService = mqttClientService;
        }
    }
}
