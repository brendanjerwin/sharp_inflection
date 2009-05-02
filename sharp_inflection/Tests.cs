using System.Collections.Generic;
using NUnit.Framework;

namespace SharpInflection
{
    [TestFixture]
    public class Tests
    {
        
        [Test]
        public void TestCamelize()
        {
            var CamelToUnderscore = new Dictionary<string, string> 
                                        { 
                                            {"Product", "product"},
                                            {"SpecialGuest" , "special_guest"},
                                            {"ApplicationController", "application_controller"},
                                            {"Area51Controller", "area51_controller"}
                                        };

            foreach (var pair in CamelToUnderscore)
            {
                Assert.AreEqual(pair.Key, Inflector.camelize(pair.Value));    
            }
            
        }

        [Test]
        public void TestCamelizeToLowerCamel()
        {
            var UnderscoreToLowerCamel = new Dictionary<string, string>
                                             {
                                                 {"product", "product"},
                                                 {"special_guest", "specialGuest"},
                                                 {"application_controller", "applicationController"},
                                                 {"area51_controller", "area51Controller"}
                                             };

            foreach (var pair in UnderscoreToLowerCamel)
            {
                Assert.AreEqual(pair.Value, Inflector.camelize(pair.Key,false));
            }
        }
    }
}