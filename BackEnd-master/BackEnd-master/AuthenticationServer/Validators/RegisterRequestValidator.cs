using AuthenticationServer.Models.Request;
using FluentValidation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AuthenticationServer.Validators
{
    public class RegisterRequestValidator : AbstractValidator<RegisterRequest>
    {
        public RegisterRequestValidator()
        {
            RuleFor(form => form.Email).NotNull();
            RuleFor(form => form.Address).NotNull();
            RuleFor(form => form.Email).NotNull();

            RuleFor(form => form.Password).NotNull();
            RuleFor(form => form.ConfirmPassword).NotNull();

            RuleFor(form => form.Password).Equal(form => form.ConfirmPassword);
        }
    }
}
